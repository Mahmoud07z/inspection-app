-- =============================================================================
-- Seed: Initial admin user
-- Password: Admin@1234   (BCrypt strength-10 hash)
-- =============================================================================
-- This file is executed automatically by Spring Boot on every startup.
-- INSERT ... ON CONFLICT DO NOTHING makes it fully idempotent — the row is
-- inserted only if a user with that username does not already exist.
-- =============================================================================
INSERT INTO users (username, email, full_name, role, password, created_at, updated_at)
VALUES (
    'admin',
    'admin@example.com',
    'Admin User',
    'ADMIN',
    '$2b$10$nxHm2kR1rNppsL/3g9nT0Og/OD1i9BMPhBE6YMTgEwWJFCXsFx0xa',
    NOW(),
    NOW()
)
ON CONFLICT (username) DO NOTHING;
