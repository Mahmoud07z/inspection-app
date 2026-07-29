package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CreateArticleRequest(

        // SKU or EAN barcode. @Pattern ensures only characters that are safe in
        // barcodes and external systems are accepted (letters, digits, hyphens,
        // underscores, dots). This rejects control characters, spaces, and
        // special chars that could cause issues in CSV exports or label printers.
        // @Pattern passes null by default — @NotBlank guards the null/empty case.
        @NotBlank(message = "Article code is required")
        @Size(max = 50, message = "Code must not exceed 50 characters")
        @Pattern(
                regexp = "^[A-Za-z0-9][A-Za-z0-9\\-_.]*$",
                message = "Article code must start with a letter or digit and may only contain letters, digits, hyphens, underscores, and dots"
        )
        String code,

        @NotBlank(message = "Article name is required")
        @Size(max = 100, message = "Name must not exceed 100 characters")
        String name,

        @Size(max = 500, message = "Description must not exceed 500 characters")
        String description

) {
}
