package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.CreateLocationRequest;
import com.inspectionapp.backend.dto.request.UpdateLocationRequest;
import com.inspectionapp.backend.dto.response.LocationResponse;
import com.inspectionapp.backend.service.LocationService;
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
 * REST controller for managing warehouse locations (aisles, shelves, bays).
 *
 * <p>Base path: {@code /api/v1/locations}
 *
 * <p>Locations are always scoped to a warehouse. The list endpoint therefore
 * requires a {@code warehouseId} query parameter — browsing all locations
 * without a warehouse context is not a supported operation.
 */
@RestController
@RequestMapping("/api/v1/locations")
@RequiredArgsConstructor
public class LocationController {

    private final LocationService locationService;

    // -------------------------------------------------------------------------
    // GET
    // -------------------------------------------------------------------------

    /**
     * Returns all locations belonging to the specified warehouse.
     *
     * <p>Example:
     * <pre>
     *   GET /api/v1/locations?warehouseId=3
     * </pre>
     *
     * @param warehouseId the warehouse whose locations to retrieve (required)
     * @return 200 OK with the location list, or 404 if the warehouse does not exist
     */
    @GetMapping
    public ResponseEntity<List<LocationResponse>> getLocationsByWarehouse(
            @RequestParam Long warehouseId) {
        return ResponseEntity.ok(locationService.getLocationsByWarehouse(warehouseId));
    }

    /**
     * Returns a single location by its database ID.
     *
     * @param id the location ID
     * @return 200 OK, or 404 if not found
     */
    @GetMapping("/{id}")
    public ResponseEntity<LocationResponse> getLocationById(@PathVariable Long id) {
        return ResponseEntity.ok(locationService.getLocationById(id));
    }

    // -------------------------------------------------------------------------
    // POST
    // -------------------------------------------------------------------------

    /**
     * Creates a new location inside a warehouse.
     *
     * <p>The {@code code} must be unique within the target warehouse (two
     * warehouses may each have an "AISLE-1", but not the same warehouse twice).
     *
     * @param request validated location payload (includes {@code warehouseId})
     * @return 201 Created with the persisted location
     */
    @PostMapping
    public ResponseEntity<LocationResponse> createLocation(
            @Valid @RequestBody CreateLocationRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(locationService.createLocation(request));
    }

    // -------------------------------------------------------------------------
    // PUT
    // -------------------------------------------------------------------------

    /**
     * Partially updates a location's {@code code} and/or {@code description}.
     *
     * <p>The parent warehouse is immutable after creation. If the code is
     * changed, the new value is checked for uniqueness within the same
     * warehouse before being applied.
     *
     * @param id      the location to update
     * @param request fields to change
     * @return 200 OK with the updated location, or 404 if not found
     */
    @PutMapping("/{id}")
    public ResponseEntity<LocationResponse> updateLocation(
            @PathVariable Long id,
            @Valid @RequestBody UpdateLocationRequest request) {
        return ResponseEntity.ok(locationService.updateLocation(id, request));
    }

    // -------------------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------------------

    /**
     * Deletes a location by ID.
     *
     * <p>Does not cascade to damage reports — existing reports retain their
     * location reference for historical traceability.
     *
     * @param id the location to delete
     * @return 204 No Content, or 404 if not found
     */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteLocation(@PathVariable Long id) {
        locationService.deleteLocation(id);
    }

}
