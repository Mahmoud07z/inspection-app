package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.DamageReport;
import com.inspectionapp.backend.entity.DamageSeverity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository for {@link DamageReport} entities.
 *
 * <p>Damage reports are the leaf-level records of the system. Common
 * access patterns: load all reports for an inspection, filter by severity,
 * find everything at a location, and aggregate counts for summaries.
 */
@Repository
public interface DamageReportRepository extends JpaRepository<DamageReport, Long> {

    // SELECT * FROM damage_reports WHERE inspection_id = ?
    // Primary query: load the full report list for a given inspection.
    List<DamageReport> findByInspectionId(Long inspectionId);

    // SELECT * FROM damage_reports WHERE article_id = ?
    // Retrieves the damage history for one article across all warehouses.
    List<DamageReport> findByArticleId(Long articleId);

    // SELECT * FROM damage_reports WHERE location_id = ?
    // Shows all damage ever recorded at a specific warehouse location.
    List<DamageReport> findByLocationId(Long locationId);

    // SELECT * FROM damage_reports WHERE severity = ?
    // Drives filtered views such as "show only CRITICAL reports".
    List<DamageReport> findBySeverity(DamageSeverity severity);

    // Combines inspection + severity — useful for summarising an inspection's
    // critical findings without loading lower-severity records.
    List<DamageReport> findByInspectionIdAndSeverity(Long inspectionId, DamageSeverity severity);

    // SELECT COUNT(*) FROM damage_reports WHERE inspection_id = ?
    // Cheap count used in inspection summary responses.
    long countByInspectionId(Long inspectionId);

    // SELECT COUNT(*) FROM damage_reports WHERE inspection_id = ? AND severity = ?
    // Powers severity breakdown widgets (e.g. "3 HIGH, 1 CRITICAL").
    long countByInspectionIdAndSeverity(Long inspectionId, DamageSeverity severity);

}
