package com.inspectionapp.backend.dto.request;

import jakarta.validation.constraints.Size;

/**
 * The warehouse code (business key) is immutable after creation.
 * Only name and address may be changed.
 *
 * <p>@Size(min=1) prevents sending an empty string that would erase the
 * current value. Null means "leave unchanged".
 */
public record UpdateWarehouseRequest(

        @Size(min = 1, max = 100, message = "Name must be between 1 and 100 characters")
        String name,

        @Size(min = 1, max = 255, message = "Address must be between 1 and 255 characters")
        String address

) {
}
