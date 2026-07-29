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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * REST controller for managing inspections — the central workflow entity that
 * ties a warehouse, an inspector, a lifecycle status, and damage reports together.
 *
 * <p>Base path: {@code /api/v1/inspections}
 *
 * <p>The list endpoint supports optional query parameters to filter results
 * without separate sub-routes. Only one filter is applied per request; the
 * priority order is {@code warehouseId → inspectorId → status}.
 */
@RestController
@RequestMapping("/api/v1/inspections")
@RequiredArgsConstructor
public class InspectionController {

	private final InspectionService inspectionService;

	// -------------------------------------------------------------------------
	// GET
	// -------------------------------------------------------------------------

	/**
	 * Returns inspections, optionally filtered by warehouse, inspector, or status.
	 *
	 * <p>Examples:
	 * <pre>
	 *   GET /api/v1/inspections                        → all inspections
	 *   GET /api/v1/inspections?warehouseId=2          → for warehouse 2
	 *   GET /api/v1/inspections?inspectorId=5          → assigned to inspector 5
	 *   GET /api/v1/inspections?status=IN_PROGRESS     → by lifecycle stage
	 * </pre>
	 *
	 * @param warehouseId  optional warehouse filter
	 * @param inspectorId  optional inspector filter
	 * @param status       optional status filter
	 * @return 200 OK with the matching list
	 */
	@GetMapping
	public ResponseEntity<List<InspectionResponse>> getInspections(
			@RequestParam(required = false) Long warehouseId,
			@RequestParam(required = false) Long inspectorId,
			@RequestParam(required = false) InspectionStatus status) {
		if (warehouseId != null) {
			return ResponseEntity.ok(inspectionService.getInspectionsByWarehouse(warehouseId));
		}
		if (inspectorId != null) {
			return ResponseEntity.ok(inspectionService.getInspectionsByInspector(inspectorId));
		}
		if (status != null) {
			return ResponseEntity.ok(inspectionService.getInspectionsByStatus(status));
		}
		return ResponseEntity.ok(inspectionService.getAllInspections());
	}

	/**
	 * Returns a single inspection by its database ID.
	 *
	 * @param id the inspection ID
	 * @return 200 OK, or 404 if not found
	 */
	@GetMapping("/{id}")
	public ResponseEntity<InspectionResponse> getInspectionById(@PathVariable Long id) {
		return ResponseEntity.ok(inspectionService.getInspectionById(id));
	}

	// -------------------------------------------------------------------------
	// POST
	// -------------------------------------------------------------------------

	/**
	 * Creates a new inspection in {@code PLANNED} status.
	 *
	 * <p>The {@code inspectionCode} must be globally unique. The referenced
	 * {@code warehouseId} and {@code inspectorId} must exist.
	 *
	 * @param request validated inspection payload
	 * @return 201 Created with the persisted inspection
	 */
	@PostMapping
	public ResponseEntity<InspectionResponse> createInspection(
			@Valid @RequestBody CreateInspectionRequest request) {
		return ResponseEntity.status(HttpStatus.CREATED).body(inspectionService.createInspection(request));
	}

	// -------------------------------------------------------------------------
	// PUT
	// -------------------------------------------------------------------------

	/**
	 * Partially updates mutable fields of an existing inspection.
	 *
	 * <p>The {@code inspectionCode}, {@code warehouseId}, and {@code inspectorId}
	 * are immutable after creation. Only non-null fields in the request body
	 * are applied (status, scheduledDate, notes).
	 *
	 * @param id      the inspection to update
	 * @param request fields to change
	 * @return 200 OK with the updated inspection, or 404 if not found
	 */
	@PutMapping("/{id}")
	public ResponseEntity<InspectionResponse> updateInspection(
			@PathVariable Long id,
			@Valid @RequestBody UpdateInspectionRequest request) {
		return ResponseEntity.ok(inspectionService.updateInspection(id, request));
	}

	// -------------------------------------------------------------------------
	// PATCH
	// -------------------------------------------------------------------------

	/**
	 * Transitions an inspection to a new lifecycle status.
	 *
	 * <p>Kept as a dedicated endpoint so the intent is explicit and
	 * status-specific validation rules can be added here later without
	 * touching the general update path.
	 *
	 * <p>Example:
	 * <pre>
	 *   PATCH /api/v1/inspections/7/status?status=COMPLETED
	 * </pre>
	 *
	 * @param id     the inspection to transition
	 * @param status the target status ({@code PLANNED}, {@code IN_PROGRESS},
	 *               {@code COMPLETED}, or {@code CANCELLED})
	 * @return 200 OK with the updated inspection, or 404 if not found
	 */
	@PatchMapping("/{id}/status")
	public ResponseEntity<InspectionResponse> updateStatus(
			@PathVariable Long id,
			@RequestParam InspectionStatus status) {
		return ResponseEntity.ok(inspectionService.updateStatus(id, status));
	}

	// -------------------------------------------------------------------------
	// DELETE
	// -------------------------------------------------------------------------

	/**
	 * Deletes an inspection by ID.
	 *
	 * <p>Cascades to all damage reports filed under this inspection
	 * (entity-level {@code CascadeType.ALL + orphanRemoval}).
	 *
	 * @param id the inspection to delete
	 * @return 204 No Content, or 404 if not found
	 */
	@DeleteMapping("/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteInspection(@PathVariable Long id) {
		inspectionService.deleteInspection(id);
	}

}
