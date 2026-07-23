package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

public record CreateInspectionRequest(
	@NotBlank(message = "Inspection code is required")
	@Size(max = 50, message = "Inspection code must not exceed 50 characters")
	String inspectionCode,

	@NotBlank(message = "Warehouse code is required")
	@Size(max = 50, message = "Warehouse code must not exceed 50 characters")
	String warehouseCode,

	@NotBlank(message = "Inspector name is required")
	@Size(max = 100, message = "Inspector name must not exceed 100 characters")
	String inspectorName,

	@NotNull(message = "Scheduled date is required")
	@FutureOrPresent(message = "Scheduled date must be today or in the future")
	LocalDate scheduledDate,

	@Size(max = 500, message = "Notes must not exceed 500 characters")
	String notes
) {
}
