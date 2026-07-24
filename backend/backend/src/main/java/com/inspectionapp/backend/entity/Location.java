package com.inspectionapp.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
// uniqueConstraints defines a composite UNIQUE index on (code, warehouse_id).
// This allows "AISLE-1" to exist in multiple warehouses, but not twice in the same one.
@Table(
    name = "locations",
    uniqueConstraints = @UniqueConstraint(
        name = "uk_location_code_warehouse",
        columnNames = {"code", "warehouse_id"}
    )
)
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Location extends BaseEntity {

    // Aisle/shelf/bay code local to the warehouse (e.g. "AISLE-3", "SHELF-B2").
    @Column(nullable = false, length = 50)
    private String code;

    @Column(length = 255)
    private String description;

    // @ManyToOne — many Locations belong to one Warehouse.
    // fetch = FetchType.LAZY prevents Hibernate from joining the warehouses table
    // every time a Location is loaded. The Warehouse is fetched on first access.
    // optional = false generates a NOT NULL constraint on the FK column and lets
    // Hibernate skip an extra null-check proxy when loading.
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    // @JoinColumn specifies the foreign key column name in the locations table.
    // Without it, Hibernate uses a default naming convention (warehouse_id already
    // matches, but explicit naming avoids surprises).
    @JoinColumn(name = "warehouse_id", nullable = false)
    private Warehouse warehouse;

    // Damage reports filed at this location. Read-only navigation; no cascade because
    // damage reports outlive location reassignments.
    @OneToMany(mappedBy = "location", fetch = FetchType.LAZY)
    @Builder.Default
    private List<DamageReport> damageReports = new ArrayList<>();

}
