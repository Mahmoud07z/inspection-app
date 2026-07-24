package com.inspectionapp.backend.exception;

/**
 * Thrown when the caller is not authenticated or presents an invalid
 * credential that is not a Spring Security authentication event.
 *
 * <h2>When to throw</h2>
 * <ul>
 *   <li>A service method needs to enforce that a valid identity is present
 *       before executing business logic (e.g. acting on behalf of a user whose
 *       token has been revoked at the application level).</li>
 *   <li>Custom token validation outside of the JWT filter (e.g. API-key
 *       endpoints).</li>
 * </ul>
 *
 * <h2>Difference from {@code BadCredentialsException}</h2>
 * Spring Security throws {@link org.springframework.security.authentication.BadCredentialsException}
 * during the login flow (wrong password). {@code UnauthorizedException} is for
 * application-layer authentication failures that occur after the filter chain.
 *
 * <h2>HTTP mapping</h2>
 * {@link com.inspectionapp.backend.exception.GlobalExceptionHandler} maps this
 * to {@code 401 Unauthorized}.
 */
public class UnauthorizedException extends RuntimeException {

    /**
     * Creates an exception with a human-readable reason.
     *
     * @param message reason shown in the API error response
     */
    public UnauthorizedException(String message) {
        super(message);
    }

    /**
     * Creates an exception that wraps a lower-level cause.
     *
     * @param message reason shown in the API error response
     * @param cause   the underlying exception
     */
    public UnauthorizedException(String message, Throwable cause) {
        super(message, cause);
    }

}
