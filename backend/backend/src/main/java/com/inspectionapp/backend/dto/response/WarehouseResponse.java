package com.inspectionapp.backend.dto.response;

import java.time.Instant;

public record WarehouseResponse(
        Long id,
        String code,
        String name,
        String address,
        Instant createdAt,
        Instant updatedAt
) {
}
