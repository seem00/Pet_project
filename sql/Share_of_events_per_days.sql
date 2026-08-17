WITH cte AS (
	SELECT
		DATE_TRUNC('day', event_time) AS day_,
		event_type,
		COUNT(*) AS count_events
	FROM events_clean_update
	GROUP BY day_, event_type
)
SELECT
	day_,
	event_type,
	count_events,
	ROUND(count_events * 100.0 / SUM(count_events) OVER (PARTITION BY day_), 2) AS share
FROM cte;





