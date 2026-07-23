package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.Inspection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InspectionRepository extends JpaRepository<Inspection, Long> {

	boolean existsByInspectionCode(String inspectionCode);

}
