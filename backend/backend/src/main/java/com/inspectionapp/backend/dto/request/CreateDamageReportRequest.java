package com.inspectionapp.backend.dto.request;

import com.inspectionapp.backend.entity.DamageSeverity;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CreateDamageReportRequest(

        @NotNull(message = "Inspection ID is required")
        Long inspectionId,

        @NotNull(message = "Article ID is required")
        Long articleId,

        @NotNull(message = "Location ID is required")
        Long locationId,

        @NotNull(message = "Severity is required")
        DamageSeverity severity,

        @NotBlank(message = "Description is required")
        @Size(max = 1000, message = "Description must not exceed 1000 characters")
        String description,

        @Size(max = 500, message = "Photo URL must not exceed 500 characters")
        String photoUrl

) {
}
