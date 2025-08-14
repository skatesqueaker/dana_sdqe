-- ODS Tables - Cleaned and normalized data
-- Schema: ods

-- Clean Business Data
CREATE TABLE IF NOT EXISTS ods.yelp_business (
    business_id VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL,
    address VARCHAR,
    city VARCHAR,
    state VARCHAR,
    postal_code VARCHAR,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    stars DECIMAL(2,1),
    review_count INTEGER,
    is_open BOOLEAN,
    categories TEXT,
    attributes TEXT,
    hours TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clean User Data
CREATE TABLE IF NOT EXISTS ods.yelp_user (
    user_id VARCHAR PRIMARY KEY,
    name VARCHAR,
    review_count INTEGER,
    yelping_since DATETIME,
    useful INTEGER,
    funny INTEGER,
    cool INTEGER,
    elite VARCHAR,
    friends VARCHAR,
    fans VARCHAR,
    average_stars DECIMAL(3,2),
    compliment_hot INTEGER,
    compliment_more INTEGER,
    compliment_profile INTEGER,
    compliment_cute INTEGER,
    compliment_list INTEGER,
    compliment_note INTEGER,
    compliment_plain INTEGER,
    compliment_cool INTEGER,
    compliment_funny INTEGER,
    compliment_writer INTEGER,
    compliment_photos INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clean Review Data
CREATE TABLE IF NOT EXISTS ods.yelp_review (
    review_id VARCHAR PRIMARY KEY,
    user_id VARCHAR NOT NULL,
    business_id VARCHAR NOT NULL,
    stars INTEGER CHECK (stars BETWEEN 1 AND 5),
    useful INTEGER DEFAULT 0,
    funny INTEGER DEFAULT 0,
    cool INTEGER DEFAULT 0,
    review_text TEXT,
    review_time DATETIME,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tip Data
CREATE TABLE IF NOT EXISTS ods.yelp_tip (
    user_id VARCHAR NOT NULL,
    business_id VARCHAR NOT NULL,
    tip_text TEXT,
    tip_time DATETIME,
    compliment_count INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Check-in Events
CREATE TABLE IF NOT EXISTS ods.yelp_checkin (
    business_id VARCHAR PRIMARY KEY,
    checkin_date TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Weather Data
CREATE TABLE IF NOT EXISTS ods.weather_precipitation (
    date VARCHAR PRIMARY KEY,
    precipitation VARCHAR,
    precipitation_normal DECIMAL(5, 2),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ods.weather_temperature (
    date VARCHAR PRIMARY KEY,
    min DECIMAL(5,2),
    max DECIMAL(5,2),
    normal_min DECIMAL(5,2),
    normal_max DECIMAL(5,2),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

