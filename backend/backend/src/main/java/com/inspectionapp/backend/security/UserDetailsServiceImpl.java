package com.inspectionapp.backend.security;

import com.inspectionapp.backend.entity.User;
import com.inspectionapp.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Bridges the application's {@link User} entity with Spring Security's
 * {@link UserDetailsService} contract.
 *
 * <h2>Role in the authentication flow</h2>
 * <ol>
 *   <li>The {@link JwtAuthenticationFilter} calls
 *       {@link #loadUserByUsername(String)} to turn a username string extracted
 *       from the JWT into a fully populated {@link UserDetails} object.</li>
 *   <li>The {@link org.springframework.security.authentication.dao.DaoAuthenticationProvider}
 *       calls the same method during the login flow to verify the submitted
 *       password against the BCrypt hash stored in the database.</li>
 * </ol>
 *
 * <h2>Authority mapping</h2>
 * The user's {@link com.inspectionapp.backend.entity.UserRole} enum constant
 * (e.g. {@code INSPECTOR}) is prefixed with {@code ROLE_} to produce a Spring
 * Security authority string ({@code ROLE_INSPECTOR}).  This is the convention
 * expected by {@code hasRole("INSPECTOR")} expressions.
 */
@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserRepository userRepository;

    /**
     * Loads a {@link UserDetails} object by username.
     *
     * <p>The returned object carries the BCrypt-hashed password so that
     * {@link org.springframework.security.authentication.dao.DaoAuthenticationProvider}
     * can perform the comparison transparently.
     *
     * @param username the login handle to look up
     * @return a fully populated {@link UserDetails} — never {@code null}
     * @throws UsernameNotFoundException if no user with that username exists
     */
    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException(
                        "User not found with username: " + username));

        // Wrap the authority in the ROLE_ prefix required by Spring Security.
        SimpleGrantedAuthority authority =
                new SimpleGrantedAuthority("ROLE_" + user.getRole().name());

        // Build a Spring Security UserDetails using the entity's BCrypt hash.
        // The plain-text password is never stored — only the hash travels here.
        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getUsername())
                .password(user.getPassword())
                .authorities(List.of(authority))
                .build();
    }

}
