-- ========================================
-- POPULATE REVIEWS FACT
-- ========================================

-- Transform reviews with all dimension keys
INSERT INTO dwh.fact_reviews
SELECT
    nextval('seq_review_key') as review_key,
    r.review_id,
    db.business_key,
    CAST(strftime(CAST(r.review_time AS DATE), '%Y%m%d') AS
VARCHAR) as date_key,
    dw.weather_key,
    r.stars as review_stars,
    COALESCE(LENGTH(r.review_text), 0) as review_length,
    CURRENT_TIMESTAMP as created_date
FROM ods.yelp_review r
JOIN dwh.dim_business db ON r.business_id = db.business_id
LEFT JOIN dwh.dim_weather dw ON dw.date_key =
CAST(strftime(CAST(r.review_time AS DATE), '%Y%m%d') AS
VARCHAR)
WHERE r.review_id IS NOT NULL
AND r.review_time IS NOT NULL
AND r.stars IS NOT NULL
AND r.stars BETWEEN 1 AND 5;
