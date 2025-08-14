-- Do people tend to review restaurants on perfect weather days?
SELECT 
    CASE WHEN w.weather_category = 'Perfect' THEN 'Perfect Weather' ELSE 'Other Weather' END as weather_type,
    COUNT(r.review_key) as review_count,
    ROUND(AVG(r.review_stars), 2) as avg_rating
FROM dwh.fact_reviews r
JOIN dwh.dim_weather w ON r.weather_key = w.weather_key
JOIN dwh.dim_business b ON r.business_key = b.business_key
WHERE b.is_restaurant = true
GROUP BY weather_type;

-- How does rain affect reviews?
SELECT 
    w.weather_category,
    COUNT(r.review_key) as review_count,
    ROUND(AVG(r.review_stars), 2) as avg_rating,
    ROUND(AVG(r.review_length), 0) as avg_review_length
FROM dwh.fact_reviews r
JOIN dwh.dim_weather w ON r.weather_key = w.weather_key
GROUP BY w.weather_category;
