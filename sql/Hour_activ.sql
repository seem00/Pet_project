WITH cte AS (
	SELECT
		EXTRACT(hour from event_time) AS hour_,
		DATE_TRUNC('day', event_time) AS day_,
		COUNT(DISTINCT user_id) AS count_users
	FROM events_clean_update
	GROUP BY hour_, day_
)
SELECT
	hour_,
	ROUND(AVG(count_users)) AS avg_users
FROM cte
GROUP BY hour_
ORDER BY hour_;





