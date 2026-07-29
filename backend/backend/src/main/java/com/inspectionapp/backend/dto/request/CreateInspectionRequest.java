package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

public record CreateInspectionRequest(

        // Human-readable business reference (e.g. "INSP-2026-001").
        // Globally unique; immutable after creation.
        @NotBlank(message = "Inspection code is required")
        @Size(max = 50, message = "Inspection code must not exceed 50 characters")
        @Pattern(
                regexp = "^[A-Za-z0-9][A-Za-z0-9\\-_.]*$",
                message = "Inspection code must start with a letter or digit and may only contain letters, digits, hyphens, underscores, and dots"
        )
        String inspectionCode,

        @NotNull(message = "Warehouse ID is required")
        Long warehouseId,

        @NotNull(message = "Inspector ID is required")
        Long inspectorId,

        // @FutureOrPresent prevents scheduling an inspection retroactively,
        // which would produce misleading audit records.
        @NotNull(message = "Scheduled date is required")
        @FutureOrPresent(message = "Scheduled date must be today or in the future")
        LocalDate scheduledDate,

        @Size(max = 500, message = "Notes must not exceed 500 characters")
        String notes
) {
}
