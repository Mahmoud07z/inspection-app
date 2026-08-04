package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateInspectionRequest;
import com.inspectionapp.backend.dto.response.InspectionResponse;

import java.util.List;

public interface InspectionService {

	List<InspectionResponse> getAllInspections();

	InspectionResponse getInspectionById(Long inspectionId);

	InspectionResponse createInspection(CreateInspectionRequest request);

}
