SELECT 
	DATE_TRUNC('week', event_time) AS date_week,
	COUNT(DISTINCT user_id) AS count_users
FROM events_clean_update
GROUP BY date_week
HAVING DATE_TRUNC('week', event_time) >= '2020-09-28'
ORDER BY date_week;