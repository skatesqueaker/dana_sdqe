-- 1. ODS Business - NULL checks
SELECT 
    'ods_business_null_check' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_business) * 100, 2) as fail_percentage
FROM ods.yelp_business 
WHERE business_id IS NULL 
   OR name IS NULL 
   OR city IS NULL;

-- 2. ODS User - Negative Values  
SELECT 
    'ods_user_neg_values' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_user) * 100, 2) as fail_percentage
FROM ods.yelp_user
WHERE review_count < 0 
   OR useful < 0 
   OR funny < 0 
   OR cool < 0
   OR average_stars NOT BETWEEN 0 AND 5;

-- 3. ODS Review - Validity
SELECT 
    'ods_review_validity' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_review) * 100, 2) as fail_percentage
FROM ods.yelp_review
WHERE stars NOT BETWEEN 1 AND 5 
   OR stars IS NULL
   OR user_id IS NULL 
   OR business_id IS NULL;

-- 4. ODS Tip - Text Content Validation
SELECT 
    'ods_tip_content_validation' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_tip) * 100, 2) as fail_percentage
FROM ods.yelp_tip
WHERE (tip_text IS NULL OR LENGTH(TRIM(tip_text)) = 0)
   OR user_id IS NULL 
   OR business_id IS NULL;

-- 5. ODS Checkin - Business Key Fields Check
SELECT 
    'ods_checkin_key_fields' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.yelp_checkin) * 100, 2) as fail_percentage
FROM ods.yelp_checkin
WHERE business_id IS NULL 
   OR checkin_date IS NULL;

-- 6. ODS Weather Precipitation - Range Validation
SELECT 
    'ods_weather_precip_validation' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.weather_precipitation) * 100, 2) as fail_percentage
FROM ods.weather_precipitation
WHERE date IS NULL
   OR (precipitation_normal IS NOT NULL AND precipitation_normal < 0);

-- 7. ODS Weather Temperature - Logical Range Check
SELECT 
    'ods_weather_temp_validation' as check_name,
    COUNT(*) as fail_count,
    ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM ods.weather_temperature) * 100, 2) as fail_percentage
FROM ods.weather_temperature
WHERE date IS NULL
   OR (min IS NOT NULL AND max IS NOT NULL AND min > max)
