package com.inspectionapp.backend.service.impl;

import com.inspectionapp.backend.dto.request.CreateLocationRequest;
import com.inspectionapp.backend.dto.request.UpdateLocationRequest;
import com.inspectionapp.backend.dto.response.LocationResponse;
import com.inspectionapp.backend.entity.Location;
import com.inspectionapp.backend.entity.Warehouse;
import com.inspectionapp.backend.exception.DuplicateResourceException;
import com.inspectionapp.backend.exception.ResourceNotFoundException;
import com.inspectionapp.backend.repository.LocationRepository;
import com.inspectionapp.backend.repository.WarehouseRepository;
import com.inspectionapp.backend.service.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Manages warehouse locations (aisles, shelves, bays).
 *
 * <p>A location code is unique within its warehouse, not globally. The service
 * enforces this composite uniqueness constraint before inserting or renaming a
 * location so that the error is reported as a {@code 409 Conflict} rather than
 * a database constraint violation bubbling up as a {@code 500}.
 *
 * <p>The parent warehouse is resolved on creation and is immutable thereafter.
 * Accessing {@code location.getWarehouse()} inside the transaction is safe
 * because all service methods run within a transaction and Hibernate will
 * lazy-load the proxy on first access.
 */
@SuppressWarnings("null")
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LocationServiceImpl implements LocationService {

    private final LocationRepository locationRepository;
    private final WarehouseRepository warehouseRepository;

    @Override
    @Transactional
    public LocationResponse createLocation(CreateLocationRequest request) {
        Warehouse warehouse = warehouseRepository.findById(request.warehouseId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Warehouse not found with id: " + request.warehouseId()));

        if (locationRepository.existsByCodeAndWarehouseId(request.code(), request.warehouseId())) {
            throw new DuplicateResourceException(
                    "Location code '" + request.code() + "' already exists in warehouse " + request.warehouseId());
        }

        Location location = Location.builder()
                .code(request.code())
                .description(request.description())
                .warehouse(warehouse)
                .build();

        return toResponse(locationRepository.save(location));
    }

    @Override
    public LocationResponse getLocationById(Long id) {
        return locationRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("Location not found with id: " + id));
    }

    @Override
    public List<LocationResponse> getLocationsByWarehouse(Long warehouseId) {
        if (!warehouseRepository.existsById(warehouseId)) {
            throw new ResourceNotFoundException("Warehouse not found with id: " + warehouseId);
        }
        return locationRepository.findByWarehouseId(warehouseId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    /**
     * If the code is being changed, the new code is checked against the
     * sibling locations in the same warehouse before being applied.
     */
    @Override
    @Transactional
    public LocationResponse updateLocation(Long id, UpdateLocationRequest request) {
        Location location = locationRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Location not found with id: " + id));

        if (request.code() != null && !request.code().equals(location.getCode())) {
            Long warehouseId = location.getWarehouse().getId();
            if (locationRepository.existsByCodeAndWarehouseId(request.code(), warehouseId)) {
                throw new DuplicateResourceException(
                        "Location code '" + request.code() + "' already exists in this warehouse");
            }
            location.setCode(request.code());
        }

        if (request.description() != null) {
            location.setDescription(request.description());
        }

        return toResponse(locationRepository.save(location));
    }

    @Override
    @Transactional
    public void deleteLocation(Long id) {
        if (!locationRepository.existsById(id)) {
            throw new ResourceNotFoundException("Location not found with id: " + id);
        }
        locationRepository.deleteById(id);
    }

    // -------------------------------------------------------------------------
    // Mapping
    // -------------------------------------------------------------------------

    private LocationResponse toResponse(Location location) {
        return new LocationResponse(
                location.getId(),
                location.getCode(),
                location.getDescription(),
                location.getWarehouse().getId(),
                location.getWarehouse().getCode(),
                location.getCreatedAt(),
                location.getUpdatedAt()
        );
    }

}
