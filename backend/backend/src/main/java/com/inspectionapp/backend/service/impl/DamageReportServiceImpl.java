package com.inspectionapp.backend.service.impl;

import com.inspectionapp.backend.dto.request.CreateDamageReportRequest;
import com.inspectionapp.backend.dto.request.UpdateDamageReportRequest;
import com.inspectionapp.backend.dto.response.DamageReportResponse;
import com.inspectionapp.backend.entity.Article;
import com.inspectionapp.backend.entity.DamageReport;
import com.inspectionapp.backend.entity.Inspection;
import com.inspectionapp.backend.entity.Location;
import com.inspectionapp.backend.exception.ResourceNotFoundException;
import com.inspectionapp.backend.repository.ArticleRepository;
import com.inspectionapp.backend.repository.DamageReportRepository;
import com.inspectionapp.backend.repository.InspectionRepository;
import com.inspectionapp.backend.repository.LocationRepository;
import com.inspectionapp.backend.service.DamageReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Manages damage reports — individual observations filed during an inspection.
 *
 * <p>On creation, all three FK references (inspection, article, location) are
 * resolved eagerly so that any missing reference is reported as a clear
 * {@code 404 Not Found} rather than a database constraint violation.
 *
 * <p>The {@code toResponse} mapping accesses lazy-loaded associations
 * ({@code inspection.inspectionCode}, {@code article.code}, etc.). This is safe
 * because all service methods run inside a transaction, so Hibernate can
 * fulfil the lazy-load without a detached-entity error.
 *
 * <p>Note: the parent inspection also owns a {@code CascadeType.ALL} +
 * {@code orphanRemoval} relationship to its damage reports. Deleting an
 * inspection therefore cascades and deletes its reports automatically — the
 * explicit {@link #deleteDamageReport(Long)} method is provided for cases where
 * an individual report must be removed without touching the parent inspection.
 */
@SuppressWarnings("null")
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DamageReportServiceImpl implements DamageReportService {

    private final DamageReportRepository damageReportRepository;
    private final InspectionRepository   inspectionRepository;
    private final ArticleRepository      articleRepository;
    private final LocationRepository     locationRepository;

    @Override
    @Transactional
    public DamageReportResponse createDamageReport(CreateDamageReportRequest request) {
        Inspection inspection = inspectionRepository.findById(request.inspectionId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Inspection not found with id: " + request.inspectionId()));

        Article article = articleRepository.findById(request.articleId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Article not found with id: " + request.articleId()));

        Location location = locationRepository.findById(request.locationId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Location not found with id: " + request.locationId()));

        DamageReport report = DamageReport.builder()
                .inspection(inspection)
                .article(article)
                .location(location)
                .severity(request.severity())
                .description(request.description())
                .photoUrl(request.photoUrl())
                .build();

        return toResponse(damageReportRepository.save(report));
    }

    @Override
    public DamageReportResponse getDamageReportById(Long id) {
        return damageReportRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("Damage report not found with id: " + id));
    }

    @Override
    public List<DamageReportResponse> getDamageReportsByInspection(Long inspectionId) {
        if (!inspectionRepository.existsById(inspectionId)) {
            throw new ResourceNotFoundException("Inspection not found with id: " + inspectionId);
        }
        return damageReportRepository.findByInspectionId(inspectionId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public List<DamageReportResponse> getDamageReportsByArticle(Long articleId) {
        if (!articleRepository.existsById(articleId)) {
            throw new ResourceNotFoundException("Article not found with id: " + articleId);
        }
        return damageReportRepository.findByArticleId(articleId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    @Transactional
    public DamageReportResponse updateDamageReport(Long id, UpdateDamageReportRequest request) {
        DamageReport report = damageReportRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Damage report not found with id: " + id));

        if (request.severity() != null) {
            report.setSeverity(request.severity());
        }
        if (request.description() != null) {
            report.setDescription(request.description());
        }
        if (request.photoUrl() != null) {
            report.setPhotoUrl(request.photoUrl());
        }

        return toResponse(damageReportRepository.save(report));
    }

    @Override
    @Transactional
    public void deleteDamageReport(Long id) {
        if (!damageReportRepository.existsById(id)) {
            throw new ResourceNotFoundException("Damage report not found with id: " + id);
        }
        damageReportRepository.deleteById(id);
    }

    // -------------------------------------------------------------------------
    // Mapping
    // -------------------------------------------------------------------------

    private DamageReportResponse toResponse(DamageReport report) {
        return new DamageReportResponse(
                report.getId(),
                report.getInspection().getId(),
                report.getInspection().getInspectionCode(),
                report.getArticle().getId(),
                report.getArticle().getCode(),
                report.getArticle().getName(),
                report.getLocation().getId(),
                report.getLocation().getCode(),
                report.getSeverity(),
                report.getDescription(),
                report.getPhotoUrl(),
                report.getCreatedAt(),
                report.getUpdatedAt()
        );
    }

}
