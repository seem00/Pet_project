SELECT
	DATE_TRUNC('month', event_time) AS date_month,
	COUNT(DISTINCT user_session) AS count_sessions
FROM events_clean_update
WHERE event_type = 'purchase' AND event_time >= '2020-10-01'
GROUP BY date_month
ORDER BY date_month;







