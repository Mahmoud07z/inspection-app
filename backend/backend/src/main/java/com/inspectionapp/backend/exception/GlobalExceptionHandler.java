package com.inspectionapp.backend.exception;

import com.inspectionapp.backend.dto.response.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.List;

/**
 * Translates every exception type thrown anywhere in the controller or service
 * layer into a consistent {@link ErrorResponse} JSON body.
 *
 * <h2>Design choices</h2>
 * <ul>
 *   <li><b>Single source of truth for HTTP status mapping.</b>  Status codes
 *       live here, not on the exception class.  This makes it trivial to audit
 *       "what does the API return for X?" without hunting through multiple
 *       files.</li>
 *   <li><b>Specific handlers before generic ones.</b>  Spring picks the most
 *       specific {@code @ExceptionHandler} first.  The catch-all
 *       {@link Exception} handler is always last.</li>
 *   <li><b>No stack trace in responses.</b>  Internal details are logged
 *       server-side; the client receives only an actionable message.  This
 *       prevents information leakage (OWASP A05).</li>
 *   <li><b>{@code errors} list for validation failures.</b>  Field-level
 *       validation errors are collected into a list so the client can display
 *       all problems at once instead of fixing them one by one.</li>
 *   <li><b>Generic {@code 401} message for credential failures.</b>  A
 *       vague message ("Invalid username or password") intentionally avoids
 *       confirming whether the username or password is wrong (OWASP A07).</li>
 * </ul>
 *
 * <h2>Exception → HTTP status catalogue</h2>
 * <pre>
 *   ResourceNotFoundException            → 404 Not Found
 *   BadRequestException                  → 400 Bad Request
 *   DuplicateResourceException           → 409 Conflict
 *   UnauthorizedException                → 401 Unauthorized
 *   BadCredentialsException              → 401 Unauthorized
 *   AccessDeniedException                → 403 Forbidden
 *   MethodArgumentNotValidException      → 400 Bad Request  (+ field errors)
 *   ConstraintViolationException         → 400 Bad Request  (+ field errors)
 *   HttpMessageNotReadableException      → 400 Bad Request
 *   MissingServletRequestParameterException → 400 Bad Request
 *   HttpRequestMethodNotSupportedException  → 405 Method Not Allowed
 *   Exception (catch-all)                → 500 Internal Server Error
 * </pre>
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

	private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

	// =========================================================================
	// 4xx — Client errors
	// =========================================================================

	// ----- 400 Bad Request ---------------------------------------------------

	/**
	 * Handles business-logic violations explicitly raised by service classes.
	 *
	 * <p>Example: attempting to re-open a {@code COMPLETED} inspection.
	 */
	@ExceptionHandler(BadRequestException.class)
	public ResponseEntity<ErrorResponse> handleBadRequest(
			BadRequestException ex, HttpServletRequest request) {
		return build(HttpStatus.BAD_REQUEST, ex.getMessage(), request);
	}

	/**
	 * Handles {@code @Valid} failures on {@code @RequestBody} parameters.
	 *
	 * <p>All field-level constraint messages are collected into the
	 * {@code errors} list so the client can fix every problem in one round-trip.
	 */
	@ExceptionHandler(MethodArgumentNotValidException.class)
	public ResponseEntity<ErrorResponse> handleValidation(
			MethodArgumentNotValidException ex, HttpServletRequest request) {
		List<String> errors = ex.getBindingResult().getFieldErrors()
				.stream()
				.map(FieldError::getDefaultMessage)
				.toList();
		return build(HttpStatus.BAD_REQUEST, "Validation failed", request, errors);
	}

	/**
	 * Handles {@code @Validated} failures on {@code @PathVariable} /
	 * {@code @RequestParam} parameters.
	 *
	 * <p>The property path (parameter name) is included in each error string
	 * for clarity.
	 */
	@ExceptionHandler(ConstraintViolationException.class)
	public ResponseEntity<ErrorResponse> handleConstraintViolation(
			ConstraintViolationException ex, HttpServletRequest request) {
		List<String> errors = ex.getConstraintViolations()
				.stream()
				.map(cv -> cv.getPropertyPath() + ": " + cv.getMessage())
				.toList();
		return build(HttpStatus.BAD_REQUEST, "Validation failed", request, errors);
	}

	/**
	 * Handles an unreadable or malformed JSON request body.
	 *
	 * <p>Thrown by the Jackson deserialiser when the payload cannot be parsed
	 * (e.g. trailing comma, wrong value type for an enum field).
	 */
	@ExceptionHandler(HttpMessageNotReadableException.class)
	public ResponseEntity<ErrorResponse> handleMessageNotReadable(
			HttpMessageNotReadableException ex, HttpServletRequest request) {
		return build(HttpStatus.BAD_REQUEST, "Malformed or unreadable request body", request);
	}

	/**
	 * Handles a missing required {@code @RequestParam}.
	 *
	 * <p>Example: {@code GET /api/v1/locations} without a required
	 * {@code warehouseId} query parameter.
	 */
	@ExceptionHandler(MissingServletRequestParameterException.class)
	public ResponseEntity<ErrorResponse> handleMissingRequestParam(
			MissingServletRequestParameterException ex, HttpServletRequest request) {
		String message = "Required parameter '" + ex.getParameterName() + "' is missing";
		return build(HttpStatus.BAD_REQUEST, message, request);
	}

	// ----- 401 Unauthorized --------------------------------------------------

	/**
	 * Handles application-layer authentication failures raised by service
	 * classes (e.g. revoked tokens, custom API-key checks).
	 */
	@ExceptionHandler(UnauthorizedException.class)
	public ResponseEntity<ErrorResponse> handleUnauthorized(
			UnauthorizedException ex, HttpServletRequest request) {
		return build(HttpStatus.UNAUTHORIZED, ex.getMessage(), request);
	}

	/**
	 * Handles Spring Security login failures (wrong username / password).
	 *
	 * <p>The message is intentionally generic to avoid user-enumeration attacks
	 * (OWASP A07 — Identification and Authentication Failures).
	 */
	@ExceptionHandler(BadCredentialsException.class)
	public ResponseEntity<ErrorResponse> handleBadCredentials(
			BadCredentialsException ex, HttpServletRequest request) {
		return build(HttpStatus.UNAUTHORIZED, "Invalid username or password", request);
	}

	// ----- 403 Forbidden -----------------------------------------------------

	/**
	 * Handles access-denied failures thrown by Spring Security's method-level
	 * security (e.g. {@code @PreAuthorize}).
	 *
	 * <p>Note: Spring Security's {@code ExceptionTranslationFilter} also
	 * handles this for filter-level rejections.  This handler covers the
	 * cases that reach the dispatcher servlet.
	 */
	@ExceptionHandler(AccessDeniedException.class)
	public ResponseEntity<ErrorResponse> handleAccessDenied(
			AccessDeniedException ex, HttpServletRequest request) {
		return build(HttpStatus.FORBIDDEN, "Access denied", request);
	}

	// ----- 404 Not Found -----------------------------------------------------

	/**
	 * Handles missing entities looked up by ID or business key.
	 *
	 * <p>Example: {@code GET /api/v1/users/999} when user 999 does not exist.
	 */
	@ExceptionHandler(ResourceNotFoundException.class)
	public ResponseEntity<ErrorResponse> handleResourceNotFound(
			ResourceNotFoundException ex, HttpServletRequest request) {
		return build(HttpStatus.NOT_FOUND, ex.getMessage(), request);
	}

	// ----- 405 Method Not Allowed --------------------------------------------

	/**
	 * Handles requests that use an HTTP method the endpoint does not support.
	 *
	 * <p>Example: {@code DELETE /api/v1/auth/login} — the path exists but
	 * only {@code POST} is mapped.
	 */
	@ExceptionHandler(HttpRequestMethodNotSupportedException.class)
	public ResponseEntity<ErrorResponse> handleMethodNotSupported(
			HttpRequestMethodNotSupportedException ex, HttpServletRequest request) {
		String message = "HTTP method '" + ex.getMethod() + "' is not supported for this endpoint";
		return build(HttpStatus.METHOD_NOT_ALLOWED, message, request);
	}

	// ----- 409 Conflict ------------------------------------------------------

	/**
	 * Handles uniqueness violations pre-checked at the service layer
	 * (before hitting the database constraint).
	 *
	 * <p>Example: creating a warehouse with a code that already exists.
	 */
	@ExceptionHandler(DuplicateResourceException.class)
	public ResponseEntity<ErrorResponse> handleDuplicateResource(
			DuplicateResourceException ex, HttpServletRequest request) {
		return build(HttpStatus.CONFLICT, ex.getMessage(), request);
	}

	// =========================================================================
	// 5xx — Server errors
	// =========================================================================

	/**
	 * Catch-all for every unhandled exception.
	 *
	 * <p>The full stack trace is logged at {@code ERROR} level for
	 * server-side diagnostics.  The client receives only a generic message
	 * to prevent internal-detail leakage (OWASP A05 — Security Misconfiguration).
	 */
	@ExceptionHandler(Exception.class)
	public ResponseEntity<ErrorResponse> handleGeneric(
			Exception ex, HttpServletRequest request) {
		log.error("Unhandled exception [{}] {}: {}",
				request.getMethod(), request.getRequestURI(), ex.getMessage(), ex);
		return build(HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred", request);
	}

	// =========================================================================
	// Shared builder
	// =========================================================================

	/**
	 * Builds a {@link ResponseEntity} with a consistent {@link ErrorResponse} body.
	 *
	 * <p>Centralising construction here ensures every response has identical
	 * field ordering and that the timestamp is always the moment the handler fires.
	 */
	private ResponseEntity<ErrorResponse> build(
			HttpStatus status, String message, HttpServletRequest request) {
		return build(status, message, request, null);
	}

	private ResponseEntity<ErrorResponse> build(
			HttpStatus status, String message, HttpServletRequest request, List<String> errors) {
		ErrorResponse body = new ErrorResponse(
				status.value(),
				message,
				Instant.now(),
				errors);
		return ResponseEntity.status(status).body(body);
	}

}
