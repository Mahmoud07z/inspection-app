package com.inspectionapp.backend.dto.response;

import com.inspectionapp.backend.entity.DamageSeverity;

import java.time.Instant;

public record DamageReportResponse(
        Long id,
        Long inspectionId,
        String inspectionCode,
        Long articleId,
        String articleCode,
        String articleName,
        Long locationId,
        String locationCode,
        DamageSeverity severity,
        String description,
        String photoUrl,
        Instant createdAt,
        Instant updatedAt
) {
}
