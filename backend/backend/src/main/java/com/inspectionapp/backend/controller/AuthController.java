package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.LoginRequest;
import com.inspectionapp.backend.dto.response.JwtResponse;
import com.inspectionapp.backend.security.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Handles authentication — the only public entry point of the API.
 *
 * <p>Base path: {@code /api/v1/auth}
 *
 * <h2>Authentication flow</h2>
 * <ol>
 *   <li>Client posts {@code { "username": "...", "password": "..." }}.</li>
 *   <li>{@link AuthenticationManager#authenticate} delegates to
 *       {@link org.springframework.security.authentication.dao.DaoAuthenticationProvider},
 *       which calls {@link UserDetailsService#loadUserByUsername} and verifies
 *       the submitted password against the BCrypt hash stored in the database.</li>
 *   <li>On success, {@link JwtUtil#generateToken} creates a signed JWT.</li>
 *   <li>The token is returned to the client as a {@link JwtResponse}.</li>
 *   <li>The client includes the token in every subsequent request:
 *       {@code Authorization: Bearer <token>}.</li>
 *   <li>Wrong credentials → {@code 401 Unauthorized} (thrown by Spring Security
 *       as a {@link org.springframework.security.authentication.BadCredentialsException},
 *       handled by {@link com.inspectionapp.backend.exception.GlobalExceptionHandler}).</li>
 * </ol>
 */
@SuppressWarnings("null")
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final UserDetailsService    userDetailsService;
    private final JwtUtil               jwtUtil;

    /**
     * Authenticates a user and returns a signed JWT.
     *
     * <p>The token is valid for the duration configured in
     * {@code app.jwt.expiration-ms} (default: 24 hours).
     *
     * @param request validated login payload
     * @return 200 OK with the JWT, token type, username, and role;
     *         or 401 Unauthorized on wrong credentials
     */
    @PostMapping("/login")
    public ResponseEntity<JwtResponse> login(@Valid @RequestBody LoginRequest request) {
        // Throws BadCredentialsException if authentication fails — caught globally.
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.username(), request.password())
        );

        // Re-load the UserDetails to build the token (authentication succeeded above).
        UserDetails userDetails = userDetailsService.loadUserByUsername(request.username());
        String token = jwtUtil.generateToken(userDetails);

        // Extract the role name without the ROLE_ prefix for a cleaner response.
        String role = userDetails.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .findFirst()
                .orElse("")
                .replace("ROLE_", "");

        return ResponseEntity.ok(new JwtResponse(token, "Bearer", userDetails.getUsername(), role));
    }

}
