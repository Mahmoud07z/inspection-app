-- =============================================================================
-- One-time database setup script
-- Run this ONCE before starting the Spring Boot backend for the first time.
--
-- How to run:
--   psql -U postgres -h localhost -f scripts/setup-database.sql
-- Or paste into pgAdmin / DBeaver Query Editor connected as a superuser.
-- =============================================================================

-- Create the application database (safe to run multiple times)
SELECT 'CREATE DATABASE inspection_app'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'inspection_app'
)\gexec

-- (Optional) Create a dedicated application user instead of using postgres:
-- CREATE USER inspection_user WITH PASSWORD 'change_me_in_production';
-- GRANT ALL PRIVILEGES ON DATABASE inspection_app TO inspection_user;
-- Then set DB_USERNAME=inspection_user and DB_PASSWORD=change_me_in_production
-- in your environment or in application.properties.
