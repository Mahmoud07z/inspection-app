package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * Payload for the {@code POST /api/v1/auth/login} endpoint.
 *
 * <p>@Size max on both fields prevents HTTP body inflation attacks:
 * BCrypt processing time scales with input length, so an attacker could
 * submit a 10 MB password to consume server CPU. Capping at the same
 * limits used during registration ensures login can never accept a
 * credential that registration would have rejected.
 */
public record LoginRequest(

        @NotBlank(message = "Username is required")
        @Size(max = 50, message = "Username must not exceed 50 characters")
        String username,

        @NotBlank(message = "Password is required")
        @Size(max = 100, message = "Password must not exceed 100 characters")
        String password

) {
}
