-- ========================================
-- POPULATE DATE DIMENSION
-- ========================================

-- Insert new dates that are not already in the dimension
INSERT OR IGNORE INTO dwh.dim_date 
SELECT DISTINCT
    CAST(strftime(CAST(r.review_time AS DATE), '%Y%m%d') AS VARCHAR) as date_key,
    CAST(r.review_time AS DATE) as date_value,
    EXTRACT(year FROM CAST(r.review_time AS DATE)) as year,
    EXTRACT(month FROM CAST(r.review_time AS DATE)) as month,
    monthname(CAST(r.review_time AS DATE)) as month_name,
    EXTRACT(dow FROM CAST(r.review_time AS DATE)) IN (0, 6) as is_weekend
FROM ods.yelp_review r
WHERE r.review_time IS NOT NULL
  AND CAST(strftime(CAST(r.review_time AS DATE), '%Y%m%d') AS VARCHAR) NOT IN (
      SELECT date_key FROM dwh.dim_date
  );

-- ========================================
-- POPULATE WEATHER DIMENSION
-- ========================================

-- Combine temperature and precipitation data by date
INSERT INTO dwh.dim_weather 
SELECT
    nextval('seq_weather_key') as weather_key,
    t.date as date_key,
    t.max as temperature_max,
    CASE
        WHEN p.precipitation = 'T' THEN 0.01
        WHEN p.precipitation IS NULL THEN 0
        ELSE CAST(p.precipitation AS DECIMAL(5,2))
    END as precipitation,
    CASE
        WHEN CASE
                WHEN p.precipitation = 'T' THEN 0.01
                WHEN p.precipitation IS NULL THEN 0
                ELSE CAST(p.precipitation AS DECIMAL(5,2))
            END > 0.3 THEN 'Rainy'
        WHEN t.max > 85 THEN 'Hot'
        WHEN t.max < 40 THEN 'Cold'
        WHEN CASE
                WHEN p.precipitation = 'T' THEN 0.01
                WHEN p.precipitation IS NULL THEN 0
                ELSE CAST(p.precipitation AS DECIMAL(5,2))
            END = 0
            AND t.max BETWEEN 65 AND 80 THEN 'Perfect'
        ELSE 'Mild'
    END as weather_category,
    CURRENT_TIMESTAMP as created_date
FROM ods.weather_temperature t
LEFT JOIN ods.weather_precipitation p ON t.date = p.date
WHERE t.date IS NOT NULL
AND t.max IS NOT NULL
AND t.date IN (
    SELECT date_key FROM dwh.dim_date
)
ON CONFLICT (date_key) DO UPDATE SET
    temperature_max = EXCLUDED.temperature_max,
    precipitation = EXCLUDED.precipitation,
    weather_category = EXCLUDED.weather_category;

-- ========================================
-- POPULATE BUSINESS DIMENSION
-- ========================================

-- Insert new businesses that are not already in the dimension
INSERT INTO dwh.dim_business
SELECT
    nextval('seq_business_key') as business_key,
    b.business_id,
    b.name as business_name,
    b.city,
    b.state,
    b.categories,
    CASE
        WHEN b.categories LIKE '%Restaurant%'
        OR b.categories LIKE '%Food%'
        OR b.categories LIKE '%Dining%'
        OR b.categories LIKE '%Cafe%'
        OR b.categories LIKE '%Bar%' THEN true
        ELSE false
    END as is_restaurant,
    CURRENT_TIMESTAMP as created_date
FROM ods.yelp_business b
WHERE b.business_id IS NOT NULL
AND b.name IS NOT NULL
ON CONFLICT (business_id) DO UPDATE SET
    business_name = EXCLUDED.business_name,
    city = EXCLUDED.city,
    state = EXCLUDED.state,
    categories = EXCLUDED.categories,
    is_restaurant = EXCLUDED.is_restaurant;
