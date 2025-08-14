-- 1. DIM Date - Completeness & Logic
SELECT 
    'dwh_date_consistency' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.dim_date) * 100, 2) as fail_percentage
FROM dwh.dim_date
WHERE date_key IS NULL 
   OR date_value IS NULL
   OR year != EXTRACT(YEAR FROM date_value)
   OR month != EXTRACT(MONTH FROM date_value);

-- 2. DIM Weather - Foreign Key Consistency  
SELECT 
    'dwh_weather_fk_consistency' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.dim_weather) * 100, 2) as fail_percentage
FROM dwh.dim_weather w
LEFT JOIN dwh.dim_date d ON w.date_key = d.date_key
WHERE d.date_key IS NULL;

-- 3. DIM Business - Duplicate Check
SELECT 
    'dwh_business_duplicates' as check_name,
    COUNT(*) - COUNT(DISTINCT business_id) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.dim_business) * 100, 2) as fail_percentage
FROM dwh.dim_business;

-- 4. FACT Reviews - Referential Integrity (Multi-table)
SELECT 
    'dwh_fact_referential_integrity' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.fact_reviews) * 100, 2) as fail_percentage
FROM dwh.fact_reviews f
LEFT JOIN dwh.dim_business b ON f.business_key = b.business_key
LEFT JOIN dwh.dim_date d ON f.date_key = d.date_key
WHERE b.business_key IS NULL 
   OR d.date_key IS NULL
   OR f.review_stars NOT BETWEEN 1 AND 5;
