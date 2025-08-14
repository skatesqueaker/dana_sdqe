DELETE FROM ods.yelp_user;

INSERT INTO ods.yelp_user (
    user_id, name, review_count, yelping_since, useful, funny, cool, elite, friends, fans, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos
)
SELECT
    TRIM(user_id) as user_id,
    TRIM(name) as name,
    CAST(review_count as INTEGER) as review_count,
    CAST(yelping_since as DATETIME) as yelping_since,
    CAST(useful as INTEGER) as useful,
    CAST(funny as INTEGER) as funny,
    CAST(cool as INTEGER) as cool,
    CAST(elite as VARCHAR) as elite,
    CAST(friends as VARCHAR) as friends,
    CAST(fans as INTEGER) as fans,
    CAST(average_stars as DECIMAL(3,2)) as average_stars,
    CAST(compliment_hot as INTEGER) as compliment_hot,
    CAST(compliment_more as INTEGER) as compliment_more,
    CAST(compliment_profile as INTEGER) as compliment_profile,
    CAST(compliment_cute as INTEGER) as compliment_cute,
    CAST(compliment_list as INTEGER) as compliment_list,
    CAST(compliment_note as INTEGER) as compliment_note,
    CAST(compliment_plain as INTEGER) as compliment_plain,
    CAST(compliment_cool as INTEGER) as compliment_cool,
    CAST(compliment_funny as INTEGER) as compliment_funny,
    CAST(compliment_writer as INTEGER) as compliment_writer,
    CAST(compliment_photos as INTEGER) as compliment_photos
FROM staging.yelp_user;
