package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateLocationRequest;
import com.inspectionapp.backend.dto.request.UpdateLocationRequest;
import com.inspectionapp.backend.dto.response.LocationResponse;

import java.util.List;

/**
 * Manages locations — specific areas (aisles, shelves, bays) inside a warehouse.
 *
 * <p>Responsibilities:
 * <ul>
 *   <li>Create a location inside a warehouse with a composite-uniqueness guard
 *       (the same code can appear in different warehouses, but not twice in the
 *       same one).</li>
 *   <li>Retrieve all locations that belong to a given warehouse.</li>
 *   <li>Apply partial updates to the code or description.</li>
 *   <li>Delete a location by ID.</li>
 * </ul>
 */
public interface LocationService {

    LocationResponse createLocation(CreateLocationRequest request);

    LocationResponse getLocationById(Long id);

    List<LocationResponse> getLocationsByWarehouse(Long warehouseId);

    LocationResponse updateLocation(Long id, UpdateLocationRequest request);

    void deleteLocation(Long id);

}
