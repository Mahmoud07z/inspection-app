package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateDamageReportRequest;
import com.inspectionapp.backend.dto.request.UpdateDamageReportRequest;
import com.inspectionapp.backend.dto.response.DamageReportResponse;

import java.util.List;

/**
 * Manages damage reports — individual observations of damaged articles
 * recorded during an inspection at a specific warehouse location.
 *
 * <p>Responsibilities:
 * <ul>
 *   <li>Create a damage report, resolving the inspection, article, and location
 *       FKs and throwing {@code ResourceNotFoundException} for any missing
 *       reference.</li>
 *   <li>Retrieve reports for a given inspection or article.</li>
 *   <li>Apply partial updates to the mutable observation fields (severity,
 *       description, photoUrl).</li>
 *   <li>Delete a report by ID (the parent inspection can also cascade-delete all
 *       its reports through the entity mapping).</li>
 * </ul>
 */
public interface DamageReportService {

    DamageReportResponse createDamageReport(CreateDamageReportRequest request);

    DamageReportResponse getDamageReportById(Long id);

    List<DamageReportResponse> getDamageReportsByInspection(Long inspectionId);

    List<DamageReportResponse> getDamageReportsByArticle(Long articleId);

    DamageReportResponse updateDamageReport(Long id, UpdateDamageReportRequest request);

    void deleteDamageReport(Long id);

}
