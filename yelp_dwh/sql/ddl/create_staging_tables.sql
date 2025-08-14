-- Staging Tables - Raw data loaded as-is from CSV files
-- Schema: staging

-- Yelp Business Data
CREATE TABLE IF NOT EXISTS staging.yelp_business (
    business_id VARCHAR PRIMARY KEY,
    name VARCHAR,
    address VARCHAR,
    city VARCHAR,
    state VARCHAR,
    postal_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    stars VARCHAR,
    review_count VARCHAR,
    is_open VARCHAR,
    attributes VARCHAR,
    categories VARCHAR,
    hours VARCHAR
);

-- Yelp User Data
CREATE TABLE IF NOT EXISTS staging.yelp_user (
    user_id VARCHAR PRIMARY KEY,
    name VARCHAR,
    review_count VARCHAR,
    yelping_since VARCHAR,
    useful VARCHAR,
    funny VARCHAR,
    cool VARCHAR,
    elite VARCHAR,
    friends VARCHAR,
    fans VARCHAR,
    average_stars VARCHAR,
    compliment_hot VARCHAR,
    compliment_more VARCHAR,
    compliment_profile VARCHAR,
    compliment_cute VARCHAR,
    compliment_list VARCHAR,
    compliment_note VARCHAR,
    compliment_plain VARCHAR,
    compliment_cool VARCHAR,
    compliment_funny VARCHAR,
    compliment_writer VARCHAR,
    compliment_photos VARCHAR
);

-- Yelp Review Data
CREATE TABLE IF NOT EXISTS staging.yelp_review (
    review_id VARCHAR PRIMARY KEY,
    user_id VARCHAR,
    business_id VARCHAR,
    stars VARCHAR,
    useful VARCHAR,
    funny VARCHAR,
    cool VARCHAR,
    text VARCHAR,
    date VARCHAR
);

-- Yelp Check-in Data
CREATE TABLE IF NOT EXISTS staging.yelp_checkin (
    business_id VARCHAR,
    date VARCHAR
);

-- Yelp Tip Data
CREATE TABLE IF NOT EXISTS staging.yelp_tip (
    user_id VARCHAR,
    business_id VARCHAR,
    text VARCHAR,
    date VARCHAR,
    compliment_count VARCHAR
);

-- Weather Precipitation Data
CREATE TABLE IF NOT EXISTS staging.us_weather_precipitation (
    date VARCHAR NOT NULL,
    precipitation VARCHAR,
    precipitation_normal VARCHAR
);

-- Weather Temperature Data
CREATE TABLE IF NOT EXISTS staging.us_weather_temperature (
    date VARCHAR NOT NULL,
    min VARCHAR,
    max VARCHAR,
    normal_min VARCHAR,
    normal_max VARCHAR
);
