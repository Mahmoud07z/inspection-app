package com.inspectionapp.backend.security;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * Intercepts every HTTP request exactly once and, when a valid JWT is present,
 * populates the {@link SecurityContextHolder} so that Spring Security treats the
 * request as authenticated.
 *
 * <h2>Request processing algorithm</h2>
 * <ol>
 *   <li>Read the {@code Authorization} header.</li>
 *   <li>If absent or not a Bearer token, pass the request through unchanged —
 *       downstream security rules will enforce authentication.</li>
 *   <li>Extract and validate the token using {@link JwtUtil}.</li>
 *   <li>If valid and no authentication is already set, load the user via
 *       {@link UserDetailsService} and store a
 *       {@link UsernamePasswordAuthenticationToken} in the
 *       {@link SecurityContextHolder}.</li>
 *   <li>On any JWT error (malformed, expired, bad signature), silently skip
 *       — do NOT write an error response here.  The downstream
 *       {@code ExceptionTranslationFilter} handles unauthenticated access by
 *       returning {@code 401 Unauthorized}.</li>
 *   <li>Always call {@code chain.doFilter()} so the request continues.</li>
 * </ol>
 *
 * <p>Extending {@link OncePerRequestFilter} guarantees this filter runs once
 * per request even in forward/include dispatch scenarios.
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    /** Bearer token prefix in the Authorization header value. */
    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtUtil            jwtUtil;
    private final UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest  request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain         filterChain)
            throws ServletException, IOException {

        // 1. Read the Authorization header.
        String authHeader = request.getHeader("Authorization");

        // 2. Skip if no Bearer token is present.
        if (authHeader == null || !authHeader.startsWith(BEARER_PREFIX)) {
            filterChain.doFilter(request, response);
            return;
        }

        // 3. Extract the raw token (strip "Bearer " prefix).
        String token = authHeader.substring(BEARER_PREFIX.length());

        try {
            String username = jwtUtil.extractUsername(token);

            // 4. Only authenticate if the context is empty (avoid re-processing).
            if (username != null &&
                    SecurityContextHolder.getContext().getAuthentication() == null) {

                UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                if (jwtUtil.isTokenValid(token, userDetails)) {
                    // 5. Build an authenticated token and attach request details
                    //    (remote IP, session ID) for audit-trail purposes.
                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(
                                    userDetails,
                                    null,                          // credentials null after auth
                                    userDetails.getAuthorities()
                            );
                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request));

                    // 6. Store in the SecurityContext — Spring Security now considers
                    //    this request authenticated for the remainder of processing.
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            }
        } catch (JwtException | IllegalArgumentException ignored) {
            // 7. Invalid token — leave the SecurityContext empty.
            //    ExceptionTranslationFilter will return 401 for protected routes.
        }

        // 8. Always continue the filter chain.
        filterChain.doFilter(request, response);
    }

}
