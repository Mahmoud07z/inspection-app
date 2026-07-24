package com.inspectionapp.backend.dto.request;

import com.inspectionapp.backend.entity.InspectionStatus;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

/**
 * All fields are optional. The inspection code, warehouse, and inspector
 * are immutable after creation.
 */
public record UpdateInspectionRequest(

        InspectionStatus status,

        @FutureOrPresent(message = "Scheduled date must be today or in the future")
        LocalDate scheduledDate,

        @Size(max = 500, message = "Notes must not exceed 500 characters")
        String notes

) {
}
