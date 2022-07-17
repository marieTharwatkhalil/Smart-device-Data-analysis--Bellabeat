--SELECT * 
--FROM fitbit.dbo.activity_daily_cleaned__06_05_2022_V01;

--SELECT * 
--FROM fitbit.dbo.activity_daily_v01 

WITH activity_daily_short AS(SELECT  id,activity_date, total_steps, total_distance, sedentary_minutes, calories
FROM fitbit.dbo.activity_daily_v01)

SELECT *, sleep_daily.total_sleep_records, sleep_daily.total_minutes_asleep, sleep_daily.total_time_in_bed, sleep_daily.total_hours_asleep, sleep_daily.total_hours_in_bed
FROM activity_daily_short 
LEFT JOIN sleep_daily_cleaned_07_05_2022_v01 AS sleep_daily
ON activity_daily_short.id = sleep_daily.id 
AND activity_daily_short.activity_date = sleep_daily.sleep_day

