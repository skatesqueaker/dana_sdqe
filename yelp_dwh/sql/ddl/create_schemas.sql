-- Database Schema Initialization

-- Staging Schema (Raw data as-is)
CREATE SCHEMA IF NOT EXISTS staging;

-- ODS Schema (Operational Data Store - Cleaned)
CREATE SCHEMA IF NOT EXISTS ods;

-- DWH Schema (Data Warehouse - Star Schema)
CREATE SCHEMA IF NOT EXISTS dwh;
