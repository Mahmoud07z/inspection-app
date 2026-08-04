package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateInspectionRequest;
import com.inspectionapp.backend.dto.request.UpdateInspectionRequest;
import com.inspectionapp.backend.dto.response.InspectionResponse;
import com.inspectionapp.backend.entity.InspectionStatus;

import java.util.List;

public interface InspectionService {

    List<InspectionResponse> getAllInspections(Long warehouseId, Long inspectorId, InspectionStatus status);

    InspectionResponse getInspectionById(Long inspectionId);

    InspectionResponse createInspection(CreateInspectionRequest request);

    InspectionResponse updateInspection(Long inspectionId, UpdateInspectionRequest request);

    InspectionResponse updateStatus(Long inspectionId, InspectionStatus status);

    void deleteInspection(Long inspectionId);
}
