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

/**
 * Manages inspections — the central aggregate of the warehouse inspection system.
 *
 * <p>The inspection code is the external business reference (e.g. "INSP-2026-001")
 * and is immutable after creation. The warehouse and inspector FK references are
 * also immutable — reassigning an inspection to a different warehouse or inspector
 * is a business decision that should create a new inspection instead.
 *
 * <p>Deleting an inspection cascades to its DamageReports through the entity
 * mapping (CascadeType.ALL + orphanRemoval = true on Inspection.damageReports).
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class InspectionServiceImpl implements InspectionService {

	private final InspectionRepository inspectionRepository;
	private final WarehouseRepository  warehouseRepository;
	private final UserRepository       userRepository;

	@Override
	public List<InspectionResponse> getAllInspections() {
		return inspectionRepository.findAll()
			.stream()
			.map(this::toResponse)
			.toList();
	}

	@Override
	public InspectionResponse getInspectionById(Long id) {
		return inspectionRepository.findById(id)
			.map(this::toResponse)
			.orElseThrow(() -> new ResourceNotFoundException("Inspection not found with id: " + id));
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

	/**
	 * Applies a partial update — only non-null fields in the request are written.
	 * The inspection code, warehouse, and inspector are immutable after creation.
	 */
	@Override
	@Transactional
	public InspectionResponse updateInspection(Long id, UpdateInspectionRequest request) {
		Inspection inspection = inspectionRepository.findById(id)
			.orElseThrow(() -> new ResourceNotFoundException("Inspection not found with id: " + id));

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

	/** Dedicated status transition — provides a clear, single-purpose endpoint. */
	@Override
	@Transactional
	public InspectionResponse updateStatus(Long id, InspectionStatus status) {
		Inspection inspection = inspectionRepository.findById(id)
			.orElseThrow(() -> new ResourceNotFoundException("Inspection not found with id: " + id));

		inspection.setStatus(status);
		return toResponse(inspectionRepository.save(inspection));
	}

	@Override
	public List<InspectionResponse> getInspectionsByWarehouse(Long warehouseId) {
		return inspectionRepository.findByWarehouseId(warehouseId)
			.stream()
			.map(this::toResponse)
			.toList();
	}

	@Override
	public List<InspectionResponse> getInspectionsByInspector(Long inspectorId) {
		return inspectionRepository.findByInspectorId(inspectorId)
			.stream()
			.map(this::toResponse)
			.toList();
	}

	@Override
	public List<InspectionResponse> getInspectionsByStatus(InspectionStatus status) {
		return inspectionRepository.findByStatus(status)
			.stream()
			.map(this::toResponse)
			.toList();
	}

	@Override
	@Transactional
	public void deleteInspection(Long id) {
		if (!inspectionRepository.existsById(id)) {
			throw new ResourceNotFoundException("Inspection not found with id: " + id);
		}
		inspectionRepository.deleteById(id);
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
			inspection.getInspector().getFullName(),
			inspection.getStatus(),
			inspection.getScheduledDate(),
			inspection.getNotes(),
			inspection.getDamageReports().size(),
			inspection.getCreatedAt(),
			inspection.getUpdatedAt()
		);
	}

}

