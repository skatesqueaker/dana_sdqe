DELETE FROM ods.yelp_checkin;

INSERT INTO ods.yelp_checkin (
    business_id, checkin_date
)
SELECT 
    TRIM(business_id) AS business_id,
    TRIM("date") AS checkin_date
FROM staging.yelp_checkin;
