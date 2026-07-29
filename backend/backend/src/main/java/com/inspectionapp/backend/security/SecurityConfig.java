package com.inspectionapp.backend.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Central Spring Security configuration.
 *
 * <h2>Design decisions</h2>
 * <ul>
 *   <li><b>Stateless sessions</b> — no {@code HttpSession} is created or used.
 *       Every request must carry a valid JWT.</li>
 *   <li><b>CSRF disabled</b> — safe for REST APIs consumed by non-browser
 *       clients; CSRF protection is only needed when cookies carry credentials.</li>
 *   <li><b>{@link JwtAuthenticationFilter} before
 *       {@link UsernamePasswordAuthenticationFilter}</b> — the JWT filter runs
 *       first, populates the {@link org.springframework.security.core.context.SecurityContextHolder},
 *       and then standard Spring Security checks proceed.</li>
 *   <li><b>{@link DaoAuthenticationProvider}</b> — wires
 *       {@link UserDetailsService} and {@link PasswordEncoder} together so
 *       the login flow can verify BCrypt-hashed passwords transparently.</li>
 *   <li><b>{@link PasswordEncoder} bean here, not in a separate class</b> —
 *       acceptable because {@link com.inspectionapp.backend.service.impl.UserServiceImpl}
 *       depends on {@code PasswordEncoder} but NOT on the security chain beans
 *       ({@link SecurityFilterChain}, {@link AuthenticationProvider}), so
 *       there is no circular dependency.</li>
 * </ul>
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

	/**
	 * JWT filter that validates tokens and sets the {@code SecurityContext}.
	 * Injected by Spring; created as a {@code @Component} in
	 * {@link JwtAuthenticationFilter}.
	 */
	private final JwtAuthenticationFilter jwtAuthenticationFilter;

	/**
	 * Loads users from the database; implemented by
	 * {@link UserDetailsServiceImpl}.
	 */
	private final UserDetailsService userDetailsService;

	// -------------------------------------------------------------------------
	// Security filter chain
	// -------------------------------------------------------------------------

	/**
	 * Defines which requests are public and which require a valid JWT,
	 * and wires the JWT filter into the chain.
	 *
	 * <p>Public endpoints:
	 * <ul>
	 *   <li>{@code GET /api/v1/health} — health check (no auth)</li>
	 *   <li>{@code POST /api/v1/auth/login} — obtain a JWT (no auth)</li>
	 * </ul>
	 * Everything else requires a valid {@code Authorization: Bearer <token>} header.
	 */
	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http
			.csrf(csrf -> csrf.disable())
			.sessionManagement(session ->
				session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
			.authorizeHttpRequests(auth -> auth
				.requestMatchers(HttpMethod.GET,  "/api/v1/health").permitAll()
				.requestMatchers(HttpMethod.POST, "/api/v1/auth/login").permitAll()
				.anyRequest().authenticated()
			)
			.authenticationProvider(authenticationProvider())
			// Run the JWT filter before Spring Security’s own form-login filter.
			.addFilterBefore(jwtAuthenticationFilter,
					UsernamePasswordAuthenticationFilter.class);

		return http.build();
	}

	// -------------------------------------------------------------------------
	// Authentication beans
	// -------------------------------------------------------------------------

	/**
	 * Configures how Spring Security authenticates users during login.
	 *
	 * <p>{@link DaoAuthenticationProvider} retrieves the user via
	 * {@link UserDetailsService} and verifies the submitted password against
	 * the BCrypt hash using the configured {@link PasswordEncoder}.
	 */
	@Bean
	public AuthenticationProvider authenticationProvider() {
		DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
		provider.setUserDetailsService(userDetailsService);
		provider.setPasswordEncoder(passwordEncoder());
		return provider;
	}

	/**
	 * Exposes Spring Security’s {@link AuthenticationManager} as a bean so it
	 * can be injected into {@link com.inspectionapp.backend.controller.AuthController}.
	 *
	 * @param config auto-configured by Spring Security
	 */
	@Bean
	public AuthenticationManager authenticationManager(AuthenticationConfiguration config)
			throws Exception {
		return config.getAuthenticationManager();
	}

	/**
	 * BCrypt password encoder with the default strength factor (10 rounds).
	 *
	 * <p>Used both here (to configure {@link DaoAuthenticationProvider}) and in
	 * {@link com.inspectionapp.backend.service.impl.UserServiceImpl} (to hash
	 * passwords before persisting new users).
	 */
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

}
