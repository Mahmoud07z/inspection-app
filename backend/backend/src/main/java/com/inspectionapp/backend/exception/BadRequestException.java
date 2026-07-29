package com.inspectionapp.backend.exception;

/**
 * Thrown when a request cannot be processed due to invalid input that is
 * not covered by Bean Validation (which uses {@link MethodArgumentNotValidException}
 * automatically).
 *
 * <h2>When to throw</h2>
 * <ul>
 *   <li>Business-rule violations that are only discoverable at the service
 *       layer — e.g. "an inspection in COMPLETED status cannot be reopened".</li>
 *   <li>Cross-field constraints that Bean Validation cannot express.</li>
 *   <li>Invalid state transitions or logically inconsistent combinations of
 *       valid individual fields.</li>
 * </ul>
 *
 * <h2>HTTP mapping</h2>
 * {@link com.inspectionapp.backend.exception.GlobalExceptionHandler} maps this
 * to {@code 400 Bad Request}.
 */
public class BadRequestException extends RuntimeException {

    /**
     * Creates an exception with a human-readable reason.
     *
     * @param message reason shown in the API error response
     */
    public BadRequestException(String message) {
        super(message);
    }

    /**
     * Creates an exception that wraps a lower-level cause.
     * Use this when the bad-request condition originates from a library
     * or infrastructure layer.
     *
     * @param message reason shown in the API error response
     * @param cause   the underlying exception
     */
    public BadRequestException(String message, Throwable cause) {
        super(message, cause);
    }

}
