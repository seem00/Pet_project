SELECT
	ROUND(SUM(price)) AS revenue,
	COUNT(*) AS count_items,
	ROUND(SUM(price) / COUNT(DISTINCT user_session)) AS aov
FROM events_clean_update
WHERE event_type = 'purchase';




