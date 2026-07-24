package com.inspectionapp.backend.dto.response;

import com.inspectionapp.backend.entity.InspectionStatus;

import java.time.Instant;
import java.time.LocalDate;

public record InspectionResponse(
	Long id,
	String inspectionCode,
	Long warehouseId,
	String warehouseCode,
	Long inspectorId,
	String inspectorName,
	InspectionStatus status,
	LocalDate scheduledDate,
	String notes,
	int damageReportCount,
	Instant createdAt,
	Instant updatedAt
) {
}
