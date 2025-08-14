DELETE FROM ods.weather_temperature;

INSERT INTO ods.weather_temperature (
    "date", 
    min,
    max,
    normal_min,
    normal_max 
)
SELECT 
    TRIM("date") as "date", 
    CAST(min as DECIMAL(5,2)) as min,
    CAST(max as DECIMAL(5,2)) as max,
    CAST(normal_min as DECIMAL(5,2)) as normal_min,
    CAST(normal_max as DECIMAL(5,2)) as normal_max 
FROM staging.us_weather_temperature;
