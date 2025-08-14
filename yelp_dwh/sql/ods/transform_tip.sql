DELETE FROM ods.yelp_tip;

INSERT INTO ods.yelp_tip (
    user_id, business_id, tip_text, tip_time, compliment_count
)
SELECT 
    TRIM(user_id) as user_id,
    TRIM(business_id) as business_id,
    TRIM("text") as tip_text,
    CAST("date" as DATETIME) as tip_time,
    CAST(compliment_count as INTEGER) as compliment_count
FROM staging.yelp_tip;
