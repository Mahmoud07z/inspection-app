package com.inspectionapp.backend.service.impl;

import com.inspectionapp.backend.dto.request.CreateWarehouseRequest;
import com.inspectionapp.backend.dto.request.UpdateWarehouseRequest;
import com.inspectionapp.backend.dto.response.WarehouseResponse;
import com.inspectionapp.backend.entity.Warehouse;
import com.inspectionapp.backend.exception.DuplicateResourceException;
import com.inspectionapp.backend.exception.ResourceNotFoundException;
import com.inspectionapp.backend.repository.WarehouseRepository;
import com.inspectionapp.backend.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Manages warehouses.
 *
 * <p>The warehouse {@code code} field is the external business key used in
 * barcodes and external integrations, so it is immutable after creation.
 * Updates are restricted to the {@code name} and {@code address} fields.
 *
 * <p>Deleting a warehouse cascades to its Locations through the
 * {@code Warehouse.locations} mapping (CascadeType.ALL + orphanRemoval = true).
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class WarehouseServiceImpl implements WarehouseService {

    private final WarehouseRepository warehouseRepository;

    @Override
    @Transactional
    public WarehouseResponse createWarehouse(CreateWarehouseRequest request) {
        if (warehouseRepository.existsByCode(request.code())) {
            throw new DuplicateResourceException("Warehouse code already exists: " + request.code());
        }

        Warehouse warehouse = Warehouse.builder()
                .code(request.code())
                .name(request.name())
                .address(request.address())
                .build();

        return toResponse(warehouseRepository.save(warehouse));
    }

    @Override
    public WarehouseResponse getWarehouseById(Long id) {
        return warehouseRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));
    }

    @Override
    public List<WarehouseResponse> getAllWarehouses() {
        return warehouseRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public List<WarehouseResponse> searchWarehouses(String name) {
        return warehouseRepository.findByNameContainingIgnoreCase(name)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    /**
     * Only name and address may be updated. The business code is immutable
     * to prevent breaking external barcode references and historical records.
     */
    @Override
    @Transactional
    public WarehouseResponse updateWarehouse(Long id, UpdateWarehouseRequest request) {
        Warehouse warehouse = warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));

        if (request.name() != null) {
            warehouse.setName(request.name());
        }
        if (request.address() != null) {
            warehouse.setAddress(request.address());
        }

        return toResponse(warehouseRepository.save(warehouse));
    }

    @Override
    @Transactional
    public void deleteWarehouse(Long id) {
        if (!warehouseRepository.existsById(id)) {
            throw new ResourceNotFoundException("Warehouse not found with id: " + id);
        }
        warehouseRepository.deleteById(id);
    }

    // -------------------------------------------------------------------------
    // Mapping
    // -------------------------------------------------------------------------

    private WarehouseResponse toResponse(Warehouse warehouse) {
        return new WarehouseResponse(
                warehouse.getId(),
                warehouse.getCode(),
                warehouse.getName(),
                warehouse.getAddress(),
                warehouse.getCreatedAt(),
                warehouse.getUpdatedAt()
        );
    }

}
