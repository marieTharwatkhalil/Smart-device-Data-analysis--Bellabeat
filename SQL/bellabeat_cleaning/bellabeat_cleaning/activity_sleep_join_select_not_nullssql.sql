WITH activity_daily_short AS(
SELECT  
	activity_daily_v01.id,
	activity_daily_v01.activity_date, 
	activity_daily_v01.total_steps,
	activity_daily_v01.total_distance,
	activity_daily_v01.sedentary_minutes, 
	activity_daily_v01.calories, 
	sleep_daily.total_sleep_records, 
	sleep_daily.total_minutes_asleep, 
	sleep_daily.total_time_in_bed, 
	sleep_daily.total_hours_asleep, 
	sleep_daily.total_hours_in_bed
FROM activity_daily_v01 
LEFT JOIN sleep_daily_cleaned_07_05_2022_v01 AS sleep_daily
ON activity_daily_v01.id = sleep_daily.id 
AND activity_daily_v01.activity_date = sleep_daily.sleep_day)
-- creating new joined table with no NULL Values 
SELECT DISTINCT * 
INTO activity_sleep_clean
FROM activity_daily_short
WHERE id IS NOT NULL  AND
	activity_date IS NOT NULL AND 
	total_steps IS NOT NULL AND
	total_distance IS NOT NULL AND
	sedentary_minutes IS NOT NULL AND 
	calories IS NOT NULL AND 
	total_sleep_records IS NOT NULL AND
	total_minutes_asleep IS NOT NULL AND
	total_time_in_bed IS NOT NULL AND
	total_hours_asleep IS NOT NULL AND 
	total_hours_in_bed IS NOT NULL 
	