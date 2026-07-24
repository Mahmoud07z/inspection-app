package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * The parent warehouse is immutable after creation.
 * Only the code and description may be updated.
 *
 * <p>@Size(min=1) prevents sending an empty string that would erase the
 * current value. Null means "leave unchanged".
 */
public record UpdateLocationRequest(

        // @Pattern allows null; the pattern is only evaluated when a value is supplied.
        @Size(min = 1, max = 50, message = "Code must be between 1 and 50 characters")
        @Pattern(
                regexp = "^[A-Za-z0-9][A-Za-z0-9\\-_.]*$",
                message = "Location code must start with a letter or digit and may only contain letters, digits, hyphens, underscores, and dots"
        )
        String code,

        @Size(max = 255, message = "Description must not exceed 255 characters")
        String description

) {
}
