SELECT
	DATE_TRUNC('month', event_time) AS month_,
	SUM(price) AS revenue
FROM events_clean_update
WHERE event_type = 'purchase' AND event_time >= '2020-10-01'
GROUP BY month_;





