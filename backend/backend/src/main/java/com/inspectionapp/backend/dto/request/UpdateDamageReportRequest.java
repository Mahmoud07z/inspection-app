package com.inspectionapp.backend.dto.request;

import com.inspectionapp.backend.entity.DamageSeverity;
import jakarta.validation.constraints.Size;

/**
 * The parent inspection, article, and location are immutable after creation.
 * Only the mutable observation fields may be corrected.
 */
public record UpdateDamageReportRequest(

        DamageSeverity severity,

        @Size(max = 1000, message = "Description must not exceed 1000 characters")
        String description,

        @Size(max = 500, message = "Photo URL must not exceed 500 characters")
        String photoUrl

) {
}
