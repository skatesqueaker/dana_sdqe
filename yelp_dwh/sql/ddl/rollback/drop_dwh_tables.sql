-- Rollback: Drop DWH Tables
-- Schema: dwh

-- Drop Indexes
DROP INDEX IF EXISTS idx_reviews_stars;
DROP INDEX IF EXISTS idx_reviews_business;
DROP INDEX IF EXISTS idx_reviews_weather;
DROP INDEX IF EXISTS idx_reviews_date;
DROP INDEX IF EXISTS idx_weather_date;

-- Drop Sequences
DROP SEQUENCE IF EXISTS seq_review_key;
DROP SEQUENCE IF EXISTS seq_business_key;
DROP SEQUENCE IF EXISTS seq_weather_key;

-- Drop Fact Tables
DROP TABLE IF EXISTS dwh.fact_reviews;

-- Drop Dimension Tables
DROP TABLE IF EXISTS dwh.dim_business;
DROP TABLE IF EXISTS dwh.dim_weather;
DROP TABLE IF EXISTS dwh.dim_date;