package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.Size;

/**
 * The article code (SKU/EAN) is the business key and is immutable after creation.
 * Only the display name and description may be updated.
 *
 * <p>@Size(min=1) on optional string fields: allows null (meaning "don't update"
 * this field) but rejects an empty string "", which would silently erase
 * the existing value and fail the NOT NULL constraint in the database.
 */
public record UpdateArticleRequest(

        @Size(min = 1, max = 100, message = "Name must be between 1 and 100 characters")
        String name,

        @Size(max = 500, message = "Description must not exceed 500 characters")
        String description

) {
}
