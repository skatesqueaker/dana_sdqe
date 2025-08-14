-- Star Schema for Weather-Review Analysis

-- Date Dimension
CREATE TABLE IF NOT EXISTS dwh.dim_date (
    date_key VARCHAR PRIMARY KEY,
    date_value DATE UNIQUE NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name VARCHAR NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- Weather Dimension
CREATE TABLE IF NOT EXISTS dwh.dim_weather (
    weather_key VARCHAR PRIMARY KEY,
    date_key VARCHAR UNIQUE NOT NULL,
    temperature_max DECIMAL(5,2),
    precipitation VARCHAR,
    weather_category VARCHAR,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Business Dimension
CREATE TABLE IF NOT EXISTS dwh.dim_business (
    business_key VARCHAR PRIMARY KEY,
    business_id VARCHAR UNIQUE NOT NULL,
    business_name VARCHAR NOT NULL,
    city VARCHAR,
    state VARCHAR,
    categories VARCHAR,
    is_restaurant BOOLEAN,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews Fact
CREATE TABLE IF NOT EXISTS dwh.fact_reviews (
    review_key VARCHAR PRIMARY KEY,
    review_id VARCHAR UNIQUE NOT NULL,
    business_key VARCHAR NOT NULL,
    date_key VARCHAR NOT NULL,
    weather_key VARCHAR,
    review_stars INTEGER CHECK (review_stars BETWEEN 1 AND 5),
    review_length INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SEQUENCES FOR AUTO-INCREMENT
CREATE SEQUENCE seq_weather_key START 1;
CREATE SEQUENCE seq_business_key START 1;
CREATE SEQUENCE seq_review_key START 1;

-- INDEXES
CREATE INDEX idx_weather_date ON dwh.dim_weather(date_key);
CREATE INDEX idx_reviews_date ON dwh.fact_reviews(date_key);
CREATE INDEX idx_reviews_weather ON dwh.fact_reviews(weather_key);
CREATE INDEX idx_reviews_business ON dwh.fact_reviews(business_key);
CREATE INDEX idx_reviews_stars ON dwh.fact_reviews(review_stars);
