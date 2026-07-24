package com.inspectionapp.backend.dto.response;

import java.time.Instant;

public record ArticleResponse(
        Long id,
        String code,
        String name,
        String description,
        Instant createdAt,
        Instant updatedAt
) {
}
