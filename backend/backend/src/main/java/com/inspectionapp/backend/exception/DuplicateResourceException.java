package com.inspectionapp.backend.exception;

/**
 * Thrown when a creation or update request would violate a uniqueness
 * constraint that the service enforces before delegating to the database.
 *
 * <p>Mapped to {@code 409 Conflict} by
 * {@link GlobalExceptionHandler#handleDuplicateResourceException}.
 */
public class DuplicateResourceException extends RuntimeException {

	/**
	 * @param message human-readable description, e.g.
	 *                {@code "Warehouse code already exists: WH-001"}
	 */
	public DuplicateResourceException(String message) {
		super(message);
	}

	/**
	 * Use when wrapping a database constraint violation.
	 */
	public DuplicateResourceException(String message, Throwable cause) {
		super(message, cause);
	}

}
