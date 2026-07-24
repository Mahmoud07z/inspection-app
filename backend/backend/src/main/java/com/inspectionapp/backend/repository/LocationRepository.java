package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository for {@link Location} entities.
 *
 * <p>Locations are scoped to a warehouse, so most queries include
 * warehouseId as a filter. Spring Data traverses the association path
 * {@code warehouse.id} when the method name uses {@code ByWarehouseId}.
 */
@Repository
public interface LocationRepository extends JpaRepository<Location, Long> {

    // SELECT * FROM locations WHERE warehouse_id = ?
    // Primary listing query: all aisles/shelves belonging to one warehouse.
    List<Location> findByWarehouseId(Long warehouseId);

    // SELECT * FROM locations WHERE code = ? AND warehouse_id = ?
    // A location code is only unique per warehouse, so both fields are needed.
    Optional<Location> findByCodeAndWarehouseId(String code, Long warehouseId);

    // SELECT COUNT(*) > 0 FROM locations WHERE code = ? AND warehouse_id = ?
    // Used before INSERT to prevent duplicate codes within the same warehouse.
    boolean existsByCodeAndWarehouseId(String code, Long warehouseId);

    // SELECT COUNT(*) FROM locations WHERE warehouse_id = ?
    // Cheap aggregate — no entity hydration needed to get a count.
    long countByWarehouseId(Long warehouseId);

    // Traverse warehouse → code to find locations by the parent's business key.
    // Spring Data joins automatically: JOIN warehouses w ON l.warehouse_id = w.id
    // WHERE w.code = ?
    List<Location> findByWarehouseCode(String warehouseCode);

}
