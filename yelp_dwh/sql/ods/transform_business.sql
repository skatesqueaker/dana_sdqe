DELETE FROM ods.yelp_business;

INSERT INTO ods.yelp_business (
    business_id, name, address, city, state, postal_code, latitude, longitude,
    stars, review_count, is_open, categories, attributes, hours
)
SELECT
    TRIM(business_id) as business_id,
    TRIM(name) as name,
    TRIM(address) as address,
    TRIM(city) as city,
    UPPER(state) as state,
    TRIM(postal_code) as postal_code,
    CAST(latitude AS DECIMAL(9,6)) as latitude,
    CAST(longitude AS DECIMAL(9,6)) as longitude,
    CAST(stars AS DECIMAL(2,1)) as stars,
    CAST(review_count AS INTEGER) as review_count,
    CASE WHEN is_open = 1 THEN true ELSE false END as is_open,
    attributes,
    categories,
    hours
FROM staging.yelp_business;
