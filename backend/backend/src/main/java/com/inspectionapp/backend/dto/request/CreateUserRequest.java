package com.inspectionapp.backend.dto.request;

import com.inspectionapp.backend.entity.UserRole;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CreateUserRequest(

        // @NotBlank rejects null, "", and whitespace-only strings in one annotation.
        // @Size caps the column length to prevent database truncation errors.
        // @Pattern ensures only safe characters are stored (prevents lookup injection
        // and unexpected characters in logs). Null is handled by @NotBlank first.
        @NotBlank(message = "Username is required")
        @Size(max = 50, message = "Username must not exceed 50 characters")
        @Pattern(
                regexp = "^[a-zA-Z0-9_.-]+$",
                message = "Username may only contain letters, digits, dots, hyphens, and underscores"
        )
        String username,

        // @Email validates the basic structural format (local@domain.tld).
        // It does NOT verify deliverability — use email confirmation for that.
        @NotBlank(message = "Email is required")
        @Email(message = "Email must be a valid address")
        @Size(max = 100, message = "Email must not exceed 100 characters")
        String email,

        @NotBlank(message = "Full name is required")
        @Size(max = 100, message = "Full name must not exceed 100 characters")
        String fullName,

        // @NotNull is used instead of @NotBlank because UserRole is an enum,
        // not a String. Jackson deserialises unknown enum constants as null,
        // so @NotNull is the right guard here.
        @NotNull(message = "Role is required")
        UserRole role,

        // Both min AND max are combined into a single @Size to produce a single,
        // clear validation error instead of two separate messages.
        // 8 characters is the NIST SP 800-63B recommended minimum.
        // 100 characters is a reasonable upper bound to prevent BCrypt DoS
        // (BCrypt processing time grows with input length; cap before it reaches
        // the 72-byte effective limit).
        @NotBlank(message = "Password is required")
        @Size(min = 8, max = 100, message = "Password must be between 8 and 100 characters")
        String password

) {
}
