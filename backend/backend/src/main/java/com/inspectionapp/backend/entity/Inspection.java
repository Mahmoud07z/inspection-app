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

	@Column(nullable = false, unique = true, length = 50)
	private String inspectionCode;

	/** The warehouse where this inspection takes place. */
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "warehouse_id", nullable = false)
	private Warehouse warehouse;

	/** The User responsible for this inspection. */
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

	/** Damage reports filed during this inspection. */
	@OneToMany(mappedBy = "inspection", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
	@Builder.Default
	private List<DamageReport> damageReports = new ArrayList<>();
}
