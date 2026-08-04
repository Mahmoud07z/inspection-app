package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.Inspection;
import com.inspectionapp.backend.entity.InspectionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InspectionRepository extends JpaRepository<Inspection, Long> {

    boolean existsByInspectionCode(String inspectionCode);

    List<Inspection> findByWarehouseId(Long warehouseId);

    List<Inspection> findByInspectorId(Long inspectorId);

    List<Inspection> findByStatus(InspectionStatus status);

    List<Inspection> findByWarehouseIdAndStatus(Long warehouseId, InspectionStatus status);
}
