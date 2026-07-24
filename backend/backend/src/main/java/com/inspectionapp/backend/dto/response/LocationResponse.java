package com.inspectionapp.backend.dto.response;

import java.time.Instant;

public record LocationResponse(
        Long id,
        String code,
        String description,
        Long warehouseId,
        String warehouseCode,
        Instant createdAt,
        Instant updatedAt
) {
}
