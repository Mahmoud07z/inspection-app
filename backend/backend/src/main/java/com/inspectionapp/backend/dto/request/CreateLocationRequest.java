package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CreateLocationRequest(

        // Aisle/shelf/bay code local to the warehouse (e.g. "AISLE-3", "SHELF-B2").
        // The composite uniqueness (code + warehouse) is enforced by the service,
        // but the format is enforced here at the boundary.
        @NotBlank(message = "Location code is required")
        @Size(max = 50, message = "Code must not exceed 50 characters")
        @Pattern(
                regexp = "^[A-Za-z0-9][A-Za-z0-9\\-_.]*$",
                message = "Location code must start with a letter or digit and may only contain letters, digits, hyphens, underscores, and dots"
        )
        String code,

        @Size(max = 255, message = "Description must not exceed 255 characters")
        String description,

        @NotNull(message = "Warehouse ID is required")
        Long warehouseId

) {
}
