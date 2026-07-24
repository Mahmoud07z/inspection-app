package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateInspectionRequest;
import com.inspectionapp.backend.dto.request.UpdateInspectionRequest;
import com.inspectionapp.backend.dto.response.InspectionResponse;
import com.inspectionapp.backend.entity.InspectionStatus;

import java.util.List;

/**
 * Manages inspections — the central workflow entity that links a warehouse,
 * an inspector, a lifecycle status, and a collection of damage reports.
 *
 * <p>Responsibilities:
 * <ul>
 *   <li>Create an inspection, resolving the warehouse and inspector FKs and
 *       enforcing uniqueness on the business code.</li>
 *   <li>Retrieve inspections individually, in full, or filtered by warehouse,
 *       inspector, or status.</li>
 *   <li>Apply partial updates to mutable fields (status, scheduledDate, notes).</li>
 *   <li>Transition status via a dedicated method — keeping the intent explicit
 *       and easy to extend with validation rules later.</li>
 *   <li>Delete an inspection; cascades to its DamageReports through the entity
 *       mapping (CascadeType.ALL + orphanRemoval).</li>
 * </ul>
 */
public interface InspectionService {

    List<InspectionResponse> getAllInspections();

    InspectionResponse getInspectionById(Long id);

    InspectionResponse createInspection(CreateInspectionRequest request);

    InspectionResponse updateInspection(Long id, UpdateInspectionRequest request);

    /** Dedicated status-transition method — kept separate for clarity and future validation hooks. */
    InspectionResponse updateStatus(Long id, InspectionStatus status);

    List<InspectionResponse> getInspectionsByWarehouse(Long warehouseId);

    List<InspectionResponse> getInspectionsByInspector(Long inspectorId);

    List<InspectionResponse> getInspectionsByStatus(InspectionStatus status);

    void deleteInspection(Long id);

}
