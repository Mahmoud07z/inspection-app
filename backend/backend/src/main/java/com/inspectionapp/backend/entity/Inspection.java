package com.inspectionapp.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

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

	@Column(nullable = false, length = 50)
	private String warehouseCode;

	@Column(nullable = false, length = 100)
	private String inspectorName;

	@Enumerated(EnumType.STRING)
	@Column(nullable = false, length = 20)
	private InspectionStatus status;

	@Column(nullable = false)
	private LocalDate scheduledDate;

	@Column(length = 500)
	private String notes;
}
