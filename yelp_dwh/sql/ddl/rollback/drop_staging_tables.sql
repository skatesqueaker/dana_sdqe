-- Rollback: Drop Staging Tables
-- Schema: staging

-- Drop Weather Tables
DROP TABLE IF EXISTS staging.us_weather_temperature;
DROP TABLE IF EXISTS staging.us_weather_precipitation;

-- Drop Yelp Tables
DROP TABLE IF EXISTS staging.yelp_tip;
DROP TABLE IF EXISTS staging.yelp_checkin;
DROP TABLE IF EXISTS staging.yelp_review;
DROP TABLE IF EXISTS staging.yelp_user;
DROP TABLE IF EXISTS staging.yelp_business;