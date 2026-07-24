package com.inspectionapp.backend.dto.response;

import java.time.Instant;
import java.util.List;

public record ErrorResponse(
	int status,
	String message,
	Instant timestamp,
	List<String> errors
) {
	public ErrorResponse(int status, String message, Instant timestamp) {
		this(status, message, timestamp, null);
	}
}
