SELECT 
	DATE_TRUNC('day', event_time) AS date_day,
	COUNT(DISTINCT user_id) AS count_users
FROM events_clean_update
GROUP BY date_day
ORDER BY date_day;