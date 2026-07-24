package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateWarehouseRequest;
import com.inspectionapp.backend.dto.request.UpdateWarehouseRequest;
import com.inspectionapp.backend.dto.response.WarehouseResponse;

import java.util.List;

/**
 * Manages warehouses — the physical locations that are inspected.
 *
 * <p>Responsibilities:
 * <ul>
 *   <li>Create warehouses with a unique-code guard (the code is used in barcodes
 *       and external references, so it must be immutable after creation).</li>
 *   <li>Retrieve all warehouses or search by name fragment.</li>
 *   <li>Apply partial updates to mutable fields (name, address).</li>
 *   <li>Delete a warehouse; cascades to its Locations via the entity mapping.</li>
 * </ul>
 */
public interface WarehouseService {

    WarehouseResponse createWarehouse(CreateWarehouseRequest request);

    WarehouseResponse getWarehouseById(Long id);

    List<WarehouseResponse> getAllWarehouses();

    /** Returns warehouses whose name contains {@code name} (case-insensitive). */
    List<WarehouseResponse> searchWarehouses(String name);

    WarehouseResponse updateWarehouse(Long id, UpdateWarehouseRequest request);

    void deleteWarehouse(Long id);

}
