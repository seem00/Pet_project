SELECT 
	DATE_TRUNC('month', event_time) AS date_month,
	COUNT(DISTINCT user_id) AS count_users
FROM events_clean_update
GROUP BY date_month
HAVING DATE_TRUNC('month', event_time) >= '2020-10-01'
ORDER BY date_month;