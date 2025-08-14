DELETE FROM ods.weather_precipitation;

INSERT INTO ods.weather_precipitation (
    "date", 
    precipitation,
    precipitation_normal 
)
SELECT 
    TRIM("date") as "date", 
    CAST(precipitation as VARCHAR) as precipitation,
    CAST(precipitation_normal as DECIMAL(5,2)) as precipitation_normal 
FROM staging.us_weather_precipitation;
