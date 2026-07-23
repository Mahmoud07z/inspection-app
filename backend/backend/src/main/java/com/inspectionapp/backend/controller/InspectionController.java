package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.CreateInspectionRequest;
import com.inspectionapp.backend.dto.response.InspectionResponse;
import com.inspectionapp.backend.service.InspectionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/inspections")
@RequiredArgsConstructor
public class InspectionController {

	private final InspectionService inspectionService;

	@GetMapping
	public ResponseEntity<List<InspectionResponse>> getAllInspections() {
		return ResponseEntity.ok(inspectionService.getAllInspections());
	}

	@GetMapping("/{inspectionId}")
	public ResponseEntity<InspectionResponse> getInspectionById(@PathVariable Long inspectionId) {
		return ResponseEntity.ok(inspectionService.getInspectionById(inspectionId));
	}

	@PostMapping
	public ResponseEntity<InspectionResponse> createInspection(@Valid @RequestBody CreateInspectionRequest request) {
		InspectionResponse response = inspectionService.createInspection(request);
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}
}
