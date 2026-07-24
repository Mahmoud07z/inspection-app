package com.inspectionapp.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "damage_reports")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class DamageReport extends BaseEntity {

    // The inspection during which this damage was discovered.
    // CascadeType: none — the parent Inspection cascades through its @OneToMany side.
    // optional = false ensures every report is tied to an inspection.
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "inspection_id", nullable = false)
    private Inspection inspection;

    // The article that is damaged. Loaded lazily to avoid unnecessary joins.
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "article_id", nullable = false)
    private Article article;

    // The exact warehouse location where the damage was observed.
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "location_id", nullable = false)
    private Location location;

    // How severe the damage is. Stored as a string ("LOW", "HIGH", etc.) for
    // readability in the database and resilience against enum reordering.
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private DamageSeverity severity;

    // Free-text description of the observed damage.
    @Column(nullable = false, length = 1000)
    private String description;

    // Optional URL to a photo stored in an object store (S3, Azure Blob, etc.).
    @Column(length = 500)
    private String photoUrl;

}
