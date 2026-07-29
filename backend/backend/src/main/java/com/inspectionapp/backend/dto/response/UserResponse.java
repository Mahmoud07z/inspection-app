package com.inspectionapp.backend.dto.response;

import com.inspectionapp.backend.entity.UserRole;

import java.time.Instant;

public record UserResponse(
        Long id,
        String username,
        String email,
        String fullName,
        UserRole role,
        Instant createdAt,
        Instant updatedAt
) {
}
