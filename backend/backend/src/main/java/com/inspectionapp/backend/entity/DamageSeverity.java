package com.inspectionapp.backend.entity;

// Severity levels for a damage report, ordered from least to most critical.
public enum DamageSeverity {

    // Minor cosmetic damage; no risk to functionality or safety.
    LOW,

    // Noticeable damage; functionality may be impaired but item still usable.
    MEDIUM,

    // Significant damage; item requires repair or withdrawal from stock.
    HIGH,

    // Severe damage; immediate quarantine required; potential safety risk.
    CRITICAL
}
