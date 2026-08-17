WITH cte AS (
	SELECT
		event_type,
		COUNT(*) AS count_events
	FROM events_clean_update
	GROUP BY event_type 
)
SELECT
	event_type,
	count_events,
	ROUND(count_events * 100.0 / SUM(count_events) OVER (), 2) AS share
FROM cte;





