package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CreateWarehouseRequest(

        // External business key used in barcodes and integrations (e.g. "WH-001").
        // Immutable after creation, so the format must be enforced on write.
        @NotBlank(message = "Warehouse code is required")
        @Size(max = 50, message = "Code must not exceed 50 characters")
        @Pattern(
                regexp = "^[A-Za-z0-9][A-Za-z0-9\\-_.]*$",
                message = "Warehouse code must start with a letter or digit and may only contain letters, digits, hyphens, underscores, and dots"
        )
        String code,

        @NotBlank(message = "Warehouse name is required")
        @Size(max = 100, message = "Name must not exceed 100 characters")
        String name,

        // @Size(min=1) is not needed here: address is optional (null = unknown),
        // but if supplied it must have meaningful content (not just whitespace).
        // @Size(min=1) allows null but rejects an empty string "".
        @Size(min = 1, max = 255, message = "Address must be between 1 and 255 characters")
        String address

) {
}
