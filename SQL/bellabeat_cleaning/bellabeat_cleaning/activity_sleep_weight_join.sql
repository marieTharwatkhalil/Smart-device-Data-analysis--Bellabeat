SELECT activity_sleep_clean.*, weight_daily_v01.weight_kg
      ,weight_daily_v01.weight_pounds
      ,weight_daily_v01.bmi
      ,weight_daily_v01.is_manual_report
FROM fitbit.dbo.activity_sleep_clean
LEFT JOIN fitbit.dbo.weight_daily_v01
ON activity_sleep_clean.id = weight_daily_v01.id
AND activity_sleep_clean.activity_date = weight_daily_v01.date
