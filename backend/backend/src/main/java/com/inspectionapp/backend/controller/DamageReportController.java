package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.CreateDamageReportRequest;
import com.inspectionapp.backend.dto.request.UpdateDamageReportRequest;
import com.inspectionapp.backend.dto.response.DamageReportResponse;
import com.inspectionapp.backend.service.DamageReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
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
 * REST controller for managing damage reports — individual observations of
 * damaged articles recorded at specific warehouse locations during an inspection.
 *
 * <p>Base path: {@code /api/v1/damage-reports}
 *
 * <p>Damage reports are always viewed in context. The list endpoint therefore
 * requires at least one of {@code inspectionId} or {@code articleId}. Attempting
 * to list without either filter returns {@code 400 Bad Request}.
 */
@RestController
@RequestMapping("/api/v1/damage-reports")
@RequiredArgsConstructor
public class DamageReportController {

    private final DamageReportService damageReportService;

    // -------------------------------------------------------------------------
    // GET
    // -------------------------------------------------------------------------

    /**
     * Returns damage reports filtered by inspection or article.
     *
     * <p>At least one filter parameter is required. If both are supplied,
     * {@code inspectionId} takes precedence.
     *
     * <p>Examples:
     * <pre>
     *   GET /api/v1/damage-reports?inspectionId=12   → all reports in inspection 12
     *   GET /api/v1/damage-reports?articleId=5       → damage history for article 5
     * </pre>
     *
     * @param inspectionId filter by parent inspection (takes precedence)
     * @param articleId    filter by damaged article
     * @return 200 OK with the matching list, or 400 if no filter is supplied
     */
    @GetMapping
    public ResponseEntity<List<DamageReportResponse>> getDamageReports(
            @RequestParam(required = false) Long inspectionId,
            @RequestParam(required = false) Long articleId) {
        if (inspectionId != null) {
            return ResponseEntity.ok(damageReportService.getDamageReportsByInspection(inspectionId));
        }
        if (articleId != null) {
            return ResponseEntity.ok(damageReportService.getDamageReportsByArticle(articleId));
        }
        // At least one filter is required — listing all reports without context
        // could return an unbounded result set.
        return ResponseEntity.badRequest().build();
    }

    /**
     * Returns a single damage report by its database ID.
     *
     * @param id the damage report ID
     * @return 200 OK, or 404 if not found
     */
    @GetMapping("/{id}")
    public ResponseEntity<DamageReportResponse> getDamageReportById(@PathVariable Long id) {
        return ResponseEntity.ok(damageReportService.getDamageReportById(id));
    }

    // -------------------------------------------------------------------------
    // POST
    // -------------------------------------------------------------------------

    /**
     * Files a new damage report.
     *
     * <p>All three FK references ({@code inspectionId}, {@code articleId},
     * {@code locationId}) must point to existing records, otherwise a
     * {@code 404 Not Found} is returned for the missing entity.
     *
     * @param request validated damage report payload
     * @return 201 Created with the persisted report
     */
    @PostMapping
    public ResponseEntity<DamageReportResponse> createDamageReport(
            @Valid @RequestBody CreateDamageReportRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(damageReportService.createDamageReport(request));
    }

    // -------------------------------------------------------------------------
    // PUT
    // -------------------------------------------------------------------------

    /**
     * Partially updates a damage report's observation fields.
     *
     * <p>The parent inspection, article, and location are immutable after
     * creation — use a new report to record a correction at a different location
     * or article. Only non-null fields ({@code severity}, {@code description},
     * {@code photoUrl}) are applied.
     *
     * @param id      the damage report to update
     * @param request fields to change
     * @return 200 OK with the updated report, or 404 if not found
     */
    @PutMapping("/{id}")
    public ResponseEntity<DamageReportResponse> updateDamageReport(
            @PathVariable Long id,
            @Valid @RequestBody UpdateDamageReportRequest request) {
        return ResponseEntity.ok(damageReportService.updateDamageReport(id, request));
    }

    // -------------------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------------------

    /**
     * Deletes a damage report by ID.
     *
     * <p>Note: deleting the parent inspection cascades and removes all its
     * damage reports automatically. This endpoint is for removing an individual
     * incorrect report without touching the rest of the inspection.
     *
     * @param id the damage report to delete
     * @return 204 No Content, or 404 if not found
     */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteDamageReport(@PathVariable Long id) {
        damageReportService.deleteDamageReport(id);
    }

}
