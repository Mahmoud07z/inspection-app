package com.inspectionapp.backend.service.impl;

import com.inspectionapp.backend.dto.request.CreateInspectionRequest;
import com.inspectionapp.backend.dto.response.InspectionResponse;
import com.inspectionapp.backend.entity.Inspection;
import com.inspectionapp.backend.entity.InspectionStatus;
import com.inspectionapp.backend.exception.DuplicateResourceException;
import com.inspectionapp.backend.exception.ResourceNotFoundException;
import com.inspectionapp.backend.repository.InspectionRepository;
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

	@Override
	public List<InspectionResponse> getAllInspections() {
		return inspectionRepository.findAll()
			.stream()
			.map(this::toResponse)
			.toList();
	}

	@Override
	public InspectionResponse getInspectionById(Long inspectionId) {
		Inspection inspection = inspectionRepository.findById(inspectionId)
			.orElseThrow(() -> new ResourceNotFoundException("Inspection not found with id: " + inspectionId));

		return toResponse(inspection);
	}

	@Override
	@Transactional
	public InspectionResponse createInspection(CreateInspectionRequest request) {
		if (inspectionRepository.existsByInspectionCode(request.inspectionCode())) {
			throw new DuplicateResourceException("Inspection code already exists: " + request.inspectionCode());
		}

		Inspection inspection = Inspection.builder()
			.inspectionCode(request.inspectionCode())
			.warehouseCode(request.warehouseCode())
			.inspectorName(request.inspectorName())
			.status(InspectionStatus.PLANNED)
			.scheduledDate(request.scheduledDate())
			.notes(request.notes())
			.build();

		return toResponse(inspectionRepository.save(inspection));
	}

	private InspectionResponse toResponse(Inspection inspection) {
		return new InspectionResponse(
			inspection.getId(),
			inspection.getInspectionCode(),
			inspection.getWarehouseCode(),
			inspection.getInspectorName(),
			inspection.getStatus(),
			inspection.getScheduledDate(),
			inspection.getNotes(),
			inspection.getCreatedAt(),
			inspection.getUpdatedAt()
		);
	}

}
