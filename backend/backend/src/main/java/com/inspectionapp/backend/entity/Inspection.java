package com.inspectionapp.backend.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@Entity
@Table(name = "inspections")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Inspection extends BaseEntity {

    // Human-readable, globally unique reference number (e.g. "INSP-2026-001").
    @Column(nullable = false, unique = true, length = 50)
    private String inspectionCode;

    // The warehouse being inspected. FetchType.LAZY avoids an automatic JOIN every
    // time an Inspection is loaded; the Warehouse is fetched on first access only.
    // optional = false adds a NOT NULL constraint and removes the extra null-check
    // proxy Hibernate would otherwise create.
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    // @JoinColumn names the FK column in the inspections table.
    @JoinColumn(name = "warehouse_id", nullable = false)
    private Warehouse warehouse;

    // The User (with role INSPECTOR) who carries out this inspection.
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "inspector_id", nullable = false)
    private User inspector;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private InspectionStatus status;

    @Column(nullable = false)
    private LocalDate scheduledDate;

    @Column(length = 500)
    private String notes;

    // One Inspection → many DamageReports.
    // CascadeType.ALL means persisting, merging, or removing an Inspection
    // automatically applies the same operation to all its DamageReports.
    // orphanRemoval = true deletes a DamageReport from the database when it is
    // removed from this list, even without an explicit EntityManager.remove() call.
    @OneToMany(mappedBy = "inspection", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    // @Builder.Default initialises the list to an empty ArrayList when the entity
    // is built via the Lombok builder, preventing NullPointerExceptions.
    @Builder.Default
    private List<DamageReport> damageReports = new ArrayList<>();

}

