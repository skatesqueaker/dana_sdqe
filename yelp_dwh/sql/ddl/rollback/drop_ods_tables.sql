-- Rollback: Drop ODS Tables
-- Schema: ods

-- Drop Weather Tables
DROP TABLE IF EXISTS ods.weather_temperature;
DROP TABLE IF EXISTS ods.weather_precipitation;

-- Drop Yelp Tables
DROP TABLE IF EXISTS ods.yelp_checkin;
DROP TABLE IF EXISTS ods.yelp_tip;
DROP TABLE IF EXISTS ods.yelp_review;
DROP TABLE IF EXISTS ods.yelp_user;
DROP TABLE IF EXISTS ods.yelp_business;