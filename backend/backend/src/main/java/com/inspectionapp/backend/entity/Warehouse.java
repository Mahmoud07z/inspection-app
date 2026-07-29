package com.inspectionapp.backend.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
// A composite unique constraint ensures that a location code is unique *within*
// its warehouse. A standalone @Column(unique=true) would enforce global uniqueness,
// which is too strict (two warehouses can share "AISLE-1").
@Table(name = "warehouses")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Warehouse extends BaseEntity {

    // Business identifier used in reports and barcodes (e.g. "WH-001").
    @Column(nullable = false, unique = true, length = 50)
    private String code;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 255)
    private String address;

    // One Warehouse → many Locations.
    // CascadeType.ALL propagates persist/merge/remove/refresh/detach from the
    // Warehouse to its Locations — if you delete a warehouse its locations are
    // deleted too (cascaded DELETE).
    // orphanRemoval = true ensures a Location removed from this list is also
    // deleted from the database even without an explicit EntityManager.remove() call.
    @OneToMany(mappedBy = "warehouse", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<Location> locations = new ArrayList<>();

    // One Warehouse → many Inspections.
    // No cascade here: removing a warehouse should not silently delete all its
    // inspections — that requires an explicit business decision.
    @OneToMany(mappedBy = "warehouse", fetch = FetchType.LAZY)
    @Builder.Default
    private List<Inspection> inspections = new ArrayList<>();

}
