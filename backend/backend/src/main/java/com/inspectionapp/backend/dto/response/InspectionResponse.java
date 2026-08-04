package com.inspectionapp.backend.dto.response;

import com.inspectionapp.backend.entity.InspectionStatus;

import java.time.Instant;
import java.time.LocalDate;

public record InspectionResponse(
	Long id,
	String inspectionCode,
	String warehouseCode,
	String inspectorName,
	InspectionStatus status,
	LocalDate scheduledDate,
	String notes,
	Instant createdAt,
	Instant updatedAt
) {
}
