package com.inspectionapp.backend.exception;

/**
 * Thrown when a requested resource cannot be found in the database.
 *
 * <p>Mapped to {@code 404 Not Found} by
 * {@link GlobalExceptionHandler#handleResourceNotFoundException}.
 */
public class ResourceNotFoundException extends RuntimeException {

	/**
	 * @param message human-readable description, e.g.
	 *                {@code "Inspection not found with id: 42"}
	 */
	public ResourceNotFoundException(String message) {
		super(message);
	}

	/**
	 * Use when wrapping a lower-level cause (e.g. an optional-based lookup).
	 */
	public ResourceNotFoundException(String message, Throwable cause) {
		super(message, cause);
	}

}
