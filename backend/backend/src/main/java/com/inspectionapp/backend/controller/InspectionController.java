package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.CreateInspectionRequest;
import com.inspectionapp.backend.dto.request.UpdateInspectionRequest;
import com.inspectionapp.backend.dto.response.InspectionResponse;
import com.inspectionapp.backend.entity.InspectionStatus;
import com.inspectionapp.backend.service.InspectionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/inspections")
@RequiredArgsConstructor
public class InspectionController {

    private final InspectionService inspectionService;

    @GetMapping
    public ResponseEntity<List<InspectionResponse>> getAllInspections(
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(required = false) Long inspectorId,
            @RequestParam(required = false) InspectionStatus status) {
        return ResponseEntity.ok(inspectionService.getAllInspections(warehouseId, inspectorId, status));
    }

    @GetMapping("/{id}")
    public ResponseEntity<InspectionResponse> getInspectionById(@PathVariable Long id) {
        return ResponseEntity.ok(inspectionService.getInspectionById(id));
    }

    @PostMapping
    public ResponseEntity<InspectionResponse> createInspection(
            @Valid @RequestBody CreateInspectionRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(inspectionService.createInspection(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<InspectionResponse> updateInspection(
            @PathVariable Long id,
            @Valid @RequestBody UpdateInspectionRequest request) {
        return ResponseEntity.ok(inspectionService.updateInspection(id, request));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<InspectionResponse> updateStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        InspectionStatus status = InspectionStatus.valueOf(body.get("status").toUpperCase());
        return ResponseEntity.ok(inspectionService.updateStatus(id, status));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteInspection(@PathVariable Long id) {
        inspectionService.deleteInspection(id);
        return ResponseEntity.noContent().build();
    }
}
