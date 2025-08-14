DELETE FROM ods.yelp_review;

INSERT INTO ods.yelp_review (
    review_id, user_id, business_id, stars, useful, funny, cool, review_text, review_time
)
SELECT
    TRIM(review_id) as review_id,
    TRIM(user_id) as user_id,
    TRIM(business_id) as business_id,
    CAST(stars as INTEGER) as stars,
    CAST(useful as INTEGER) as useful,
    CAST(funny as INTEGER) as funny,
    CAST(cool as INTEGER) as cool,
    CAST(text as TEXT) as review_text,
    CAST("date" as DATETIME) as review_time
FROM staging.yelp_review;
