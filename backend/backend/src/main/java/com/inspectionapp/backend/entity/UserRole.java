package com.inspectionapp.backend.entity;

// Roles that a User can hold within the inspection system.
public enum UserRole {

    // Full system access: can manage warehouses, users, articles, and view all reports.
    ADMIN,

    // Field operator: can perform inspections and file damage reports.
    INSPECTOR
}
