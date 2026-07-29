package com.inspectionapp.backend.dto.request;

import com.inspectionapp.backend.entity.UserRole;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * All fields are optional. Only non-null values are applied to the existing entity.
 * This allows a PATCH-style update: send only what you want to change.
 *
 * <p>@Size(min=1) is used instead of @NotBlank on optional string fields because:
 * @NotBlank also rejects null (which here means "don't update"), whereas
 * @Size(min=1) allows null but rejects an empty-string "" that would
 * silently erase the current value.
 */
public record UpdateUserRequest(

        // @Pattern is safe to use on nullable fields: @Pattern allows null by
        // default in Bean Validation, so a missing username field is accepted.
        @Size(min = 1, max = 50, message = "Username must be between 1 and 50 characters")
        @Pattern(
                regexp = "^[a-zA-Z0-9_.-]+$",
                message = "Username may only contain letters, digits, dots, hyphens, and underscores"
        )
        String username,

        @Email(message = "Email must be a valid address")
        @Size(max = 100, message = "Email must not exceed 100 characters")
        String email,

        @Size(min = 1, max = 100, message = "Full name must be between 1 and 100 characters")
        String fullName,

        UserRole role

) {
}
