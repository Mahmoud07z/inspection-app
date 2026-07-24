package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.Inspection;
import com.inspectionapp.backend.entity.InspectionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repository for {@link Inspection} entities.
 *
 * <p>Inspections are the central aggregate: they link a warehouse, an inspector,
 * a status, and a collection of damage reports. Most dashboard and reporting
 * queries filter by warehouse, inspector, or status — all covered below.
 */
@Repository
public interface InspectionRepository extends JpaRepository<Inspection, Long> {

    // SELECT * FROM inspections WHERE inspection_code = ?
    // Useful when external systems reference inspections by their business code.
    Optional<Inspection> findByInspectionCode(String inspectionCode);

    // SELECT COUNT(*) > 0 FROM inspections WHERE inspection_code = ?
    // Fast duplicate-code guard used before INSERT.
    boolean existsByInspectionCode(String inspectionCode);

    // SELECT * FROM inspections WHERE warehouse_id = ?
    // Retrieves the full inspection history for one warehouse.
    List<Inspection> findByWarehouseId(Long warehouseId);

    // SELECT * FROM inspections WHERE inspector_id = ?
    // Retrieves all inspections assigned to a particular inspector.
    List<Inspection> findByInspectorId(Long inspectorId);

    // SELECT * FROM inspections WHERE status = ?
    // Drives dashboards that group inspections by lifecycle stage.
    List<Inspection> findByStatus(InspectionStatus status);

    // Combines inspector + status — useful for "my open inspections" views.
    List<Inspection> findByInspectorIdAndStatus(Long inspectorId, InspectionStatus status);

    // Combines warehouse + status — useful for operations team dashboards.
    List<Inspection> findByWarehouseIdAndStatus(Long warehouseId, InspectionStatus status);

    // SELECT * FROM inspections WHERE scheduled_date BETWEEN ? AND ?
    // Powers calendar and planning views.
    List<Inspection> findByScheduledDateBetween(LocalDate from, LocalDate to);

    // SELECT COUNT(*) FROM inspections WHERE warehouse_id = ?
    // Aggregate that avoids loading full entities.
    long countByWarehouseId(Long warehouseId);

    // SELECT COUNT(*) FROM inspections WHERE status = ?
    long countByStatus(InspectionStatus status);

}
