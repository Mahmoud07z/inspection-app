package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.CreateWarehouseRequest;
import com.inspectionapp.backend.dto.request.UpdateWarehouseRequest;
import com.inspectionapp.backend.dto.response.WarehouseResponse;
import com.inspectionapp.backend.service.WarehouseService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * REST controller for managing warehouses — the physical locations that are
 * inspected.
 *
 * <p>Base path: {@code /api/v1/warehouses}
 */
@RestController
@RequestMapping("/api/v1/warehouses")
@RequiredArgsConstructor
public class WarehouseController {

    private final WarehouseService warehouseService;

    // -------------------------------------------------------------------------
    // GET
    // -------------------------------------------------------------------------

    /**
     * Returns all warehouses, optionally filtered by a name fragment.
     *
     * <p>Examples:
     * <pre>
     *   GET /api/v1/warehouses             → all warehouses
     *   GET /api/v1/warehouses?name=north  → warehouses whose name contains "north"
     * </pre>
     *
     * @param name optional partial name filter (case-insensitive)
     * @return 200 OK with the matching list
     */
    @GetMapping
    public ResponseEntity<List<WarehouseResponse>> getWarehouses(
            @RequestParam(required = false) String name) {
        List<WarehouseResponse> warehouses = (name != null && !name.isBlank())
                ? warehouseService.searchWarehouses(name)
                : warehouseService.getAllWarehouses();
        return ResponseEntity.ok(warehouses);
    }

    /**
     * Returns a single warehouse by its database ID.
     *
     * @param id the warehouse ID
     * @return 200 OK, or 404 if not found
     */
    @GetMapping("/{id}")
    public ResponseEntity<WarehouseResponse> getWarehouseById(@PathVariable Long id) {
        return ResponseEntity.ok(warehouseService.getWarehouseById(id));
    }

    // -------------------------------------------------------------------------
    // POST
    // -------------------------------------------------------------------------

    /**
     * Creates a new warehouse.
     *
     * <p>The {@code code} field is the immutable external business key (used in
     * barcodes and integrations) and must be unique across the system.
     *
     * @param request validated warehouse payload
     * @return 201 Created with the persisted warehouse
     */
    @PostMapping
    public ResponseEntity<WarehouseResponse> createWarehouse(
            @Valid @RequestBody CreateWarehouseRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(warehouseService.createWarehouse(request));
    }

    // -------------------------------------------------------------------------
    // PUT
    // -------------------------------------------------------------------------

    /**
     * Partially updates an existing warehouse.
     *
     * <p>Only {@code name} and {@code address} may be changed. The {@code code}
     * is immutable after creation to preserve external barcode references.
     * Only non-null fields in the request body are applied.
     *
     * @param id      the warehouse to update
     * @param request fields to change
     * @return 200 OK with the updated warehouse, or 404 if not found
     */
    @PutMapping("/{id}")
    public ResponseEntity<WarehouseResponse> updateWarehouse(
            @PathVariable Long id,
            @Valid @RequestBody UpdateWarehouseRequest request) {
        return ResponseEntity.ok(warehouseService.updateWarehouse(id, request));
    }

    // -------------------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------------------

    /**
     * Deletes a warehouse by ID.
     *
     * <p>Cascades to all locations belonging to the warehouse (entity-level
     * {@code CascadeType.ALL + orphanRemoval}).
     *
     * @param id the warehouse to delete
     * @return 204 No Content, or 404 if not found
     */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteWarehouse(@PathVariable Long id) {
        warehouseService.deleteWarehouse(id);
    }

}
