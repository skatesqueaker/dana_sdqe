-- Rollback: Drop Database Schemas
-- WARNING: This will drop all tables and data in these schemas

-- Drop DWH Schema (Data Warehouse)
DROP SCHEMA IF EXISTS dwh CASCADE;

-- Drop ODS Schema (Operational Data Store)
DROP SCHEMA IF EXISTS ods CASCADE;

-- Drop Staging Schema (Raw data)
DROP SCHEMA IF EXISTS staging CASCADE;