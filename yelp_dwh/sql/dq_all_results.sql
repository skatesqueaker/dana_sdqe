-- Centralized Data Quality Results
-- Combines all ODS and DWH DQ checks into one result set

-- ODS Layer DQ Checks
SELECT 
    'ODS' as layer,
    'ods_business_null_check' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_business) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_business) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM ods.yelp_business 
WHERE business_id IS NULL 
   OR name IS NULL 
   OR city IS NULL

UNION ALL

SELECT 
    'ODS' as layer,
    'ods_user_neg_values' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_user) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_user) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM ods.yelp_user
WHERE review_count < 0 
   OR useful < 0 
   OR funny < 0 
   OR cool < 0
   OR average_stars NOT BETWEEN 0 AND 5

UNION ALL

SELECT 
    'ODS' as layer,
    'ods_review_validity' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_review) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_review) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM ods.yelp_review
WHERE stars NOT BETWEEN 1 AND 5 
   OR stars IS NULL
   OR user_id IS NULL 
   OR business_id IS NULL

UNION ALL

SELECT 
    'ODS' as layer,
    'ods_tip_content_validation' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_tip) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_tip) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM ods.yelp_tip
WHERE (tip_text IS NULL OR LENGTH(TRIM(tip_text)) = 0)
   OR user_id IS NULL 
   OR business_id IS NULL

UNION ALL

SELECT 
    'ODS' as layer,
    'ods_checkin_key_fields' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_checkin) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_checkin) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM ods.yelp_checkin
WHERE business_id IS NULL 
   OR checkin_date IS NULL

UNION ALL

SELECT 
    'ODS' as layer,
    'ods_weather_precip_validation' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.weather_precipitation) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.weather_precipitation) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM ods.weather_precipitation
WHERE date IS NULL
   OR (precipitation_normal IS NOT NULL AND precipitation_normal < 0)

UNION ALL

SELECT 
    'ODS' as layer,
    'ods_weather_temp_validation' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.weather_temperature) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.weather_temperature) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM ods.weather_temperature
WHERE date IS NULL
   OR (min IS NOT NULL AND max IS NOT NULL AND min > max)

UNION ALL

-- DWH Layer DQ Checks
SELECT 
    'DWH' as layer,
    'dwh_date_consistency' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.dim_date) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.dim_date) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM dwh.dim_date
WHERE date_key IS NULL 
   OR date_value IS NULL
   OR year != EXTRACT(YEAR FROM date_value)
   OR month != EXTRACT(MONTH FROM date_value)

UNION ALL

SELECT 
    'DWH' as layer,
    'dwh_weather_fk_consistency' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.dim_weather) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.dim_weather) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM dwh.dim_weather w
LEFT JOIN dwh.dim_date d ON w.date_key = d.date_key
WHERE d.date_key IS NULL

UNION ALL

SELECT 
    'DWH' as layer,
    'dwh_business_duplicates' as check_name,
    COUNT(*) - COUNT(DISTINCT business_id) as fail_count,
    ROUND((COUNT(*) - COUNT(DISTINCT business_id))::decimal / (SELECT COUNT(*) FROM dwh.dim_business) * 100, 2) as fail_percentage,
    CASE WHEN ROUND((COUNT(*) - COUNT(DISTINCT business_id))::decimal / (SELECT COUNT(*) FROM dwh.dim_business) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM dwh.dim_business

UNION ALL

SELECT 
    'DWH' as layer,
    'dwh_fact_referential_integrity' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.fact_reviews) * 100, 2) as fail_percentage,
    CASE WHEN ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM dwh.fact_reviews) * 100, 2) > 5 THEN 'FAIL' ELSE 'PASS' END as status
FROM dwh.fact_reviews f
LEFT JOIN dwh.dim_business b ON f.business_key = b.business_key
LEFT JOIN dwh.dim_date d ON f.date_key = d.date_key
WHERE b.business_key IS NULL 
   OR d.date_key IS NULL
   OR f.review_stars NOT BETWEEN 1 AND 5

ORDER BY layer, check_name;