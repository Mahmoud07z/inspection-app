package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.Warehouse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository for {@link Warehouse} entities.
 *
 * <p>findBy + field name is enough for simple lookups.
 * Spring Data generates the JPQL at startup and caches it — zero runtime overhead.
 */
@Repository
public interface WarehouseRepository extends JpaRepository<Warehouse, Long> {

    // SELECT * FROM warehouses WHERE code = ?
    // Useful when callers have a barcode/QR value rather than a database ID.
    Optional<Warehouse> findByCode(String code);

    // SELECT COUNT(*) > 0 FROM warehouses WHERE code = ?
    // Used before INSERT to prevent duplicate codes.
    boolean existsByCode(String code);

    // Partial, case-insensitive name search for autocomplete / search boxes.
    List<Warehouse> findByNameContainingIgnoreCase(String name);

    // Useful for listings filtered by city or region when address contains that text.
    List<Warehouse> findByAddressContainingIgnoreCase(String address);

}
