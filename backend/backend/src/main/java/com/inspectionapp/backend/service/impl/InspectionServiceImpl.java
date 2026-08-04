package com.inspectionapp.backend.service.impl;

import com.inspectionapp.backend.dto.request.CreateInspectionRequest;
import com.inspectionapp.backend.dto.request.UpdateInspectionRequest;
import com.inspectionapp.backend.dto.response.InspectionResponse;
import com.inspectionapp.backend.entity.Inspection;
import com.inspectionapp.backend.entity.InspectionStatus;
import com.inspectionapp.backend.entity.User;
import com.inspectionapp.backend.entity.Warehouse;
import com.inspectionapp.backend.exception.DuplicateResourceException;
import com.inspectionapp.backend.exception.ResourceNotFoundException;
import com.inspectionapp.backend.repository.InspectionRepository;
import com.inspectionapp.backend.repository.UserRepository;
import com.inspectionapp.backend.repository.WarehouseRepository;
import com.inspectionapp.backend.service.InspectionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class InspectionServiceImpl implements InspectionService {

    private final InspectionRepository inspectionRepository;
    private final WarehouseRepository  warehouseRepository;
    private final UserRepository       userRepository;

    @Override
    public List<InspectionResponse> getAllInspections(Long warehouseId, Long inspectorId, InspectionStatus status) {
        List<Inspection> results;
        if (warehouseId != null && status != null) {
            results = inspectionRepository.findByWarehouseIdAndStatus(warehouseId, status);
        } else if (warehouseId != null) {
            results = inspectionRepository.findByWarehouseId(warehouseId);
        } else if (inspectorId != null) {
            results = inspectionRepository.findByInspectorId(inspectorId);
        } else if (status != null) {
            results = inspectionRepository.findByStatus(status);
        } else {
            results = inspectionRepository.findAll();
        }
        return results.stream().map(this::toResponse).toList();
    }

    @Override
    public InspectionResponse getInspectionById(Long inspectionId) {
        return inspectionRepository.findById(inspectionId)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("Inspection not found with id: " + inspectionId));
    }

    @Override
    @Transactional
    public InspectionResponse createInspection(CreateInspectionRequest request) {
        if (inspectionRepository.existsByInspectionCode(request.inspectionCode())) {
            throw new DuplicateResourceException("Inspection code already exists: " + request.inspectionCode());
        }

        Warehouse warehouse = warehouseRepository.findById(request.warehouseId())
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + request.warehouseId()));

        User inspector = userRepository.findById(request.inspectorId())
                .orElseThrow(() -> new ResourceNotFoundException("Inspector not found with id: " + request.inspectorId()));

        Inspection inspection = Inspection.builder()
                .inspectionCode(request.inspectionCode())
                .warehouse(warehouse)
                .inspector(inspector)
                .status(InspectionStatus.PLANNED)
                .scheduledDate(request.scheduledDate())
                .notes(request.notes())
                .build();

        return toResponse(inspectionRepository.save(inspection));
    }

    @Override
    @Transactional
    public InspectionResponse updateInspection(Long inspectionId, UpdateInspectionRequest request) {
        Inspection inspection = inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new ResourceNotFoundException("Inspection not found with id: " + inspectionId));

        if (request.status() != null) {
            inspection.setStatus(request.status());
        }
        if (request.scheduledDate() != null) {
            inspection.setScheduledDate(request.scheduledDate());
        }
        if (request.notes() != null) {
            inspection.setNotes(request.notes());
        }

        return toResponse(inspectionRepository.save(inspection));
    }

    @Override
    @Transactional
    public InspectionResponse updateStatus(Long inspectionId, InspectionStatus status) {
        Inspection inspection = inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new ResourceNotFoundException("Inspection not found with id: " + inspectionId));
        inspection.setStatus(status);
        return toResponse(inspectionRepository.save(inspection));
    }

    @Override
    @Transactional
    public void deleteInspection(Long inspectionId) {
        if (!inspectionRepository.existsById(inspectionId)) {
            throw new ResourceNotFoundException("Inspection not found with id: " + inspectionId);
        }
        inspectionRepository.deleteById(inspectionId);
    }

    // -------------------------------------------------------------------------
    // Mapping
    // -------------------------------------------------------------------------
    private InspectionResponse toResponse(Inspection inspection) {
        return new InspectionResponse(
                inspection.getId(),
                inspection.getInspectionCode(),
                inspection.getWarehouse().getId(),
                inspection.getWarehouse().getCode(),
                inspection.getInspector().getId(),
                inspection.getInspector().getUsername(),
                inspection.getStatus(),
                inspection.getScheduledDate(),
                inspection.getNotes(),
                inspection.getDamageReports().size(),
                inspection.getCreatedAt(),
                inspection.getUpdatedAt()
        );
    }
}
