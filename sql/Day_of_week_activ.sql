WITH cte AS (
	SELECT
		day_of_week,
		DATE_TRUNC('day', event_time) AS day_,
		COUNT(DISTINCT user_id) AS count_users,
		CASE	
			WHEN day_of_week = 'Monday' THEN 1
			WHEN day_of_week = 'Tuesday' THEN 2
			WHEN day_of_week = 'Wednesday' THEN 3
			WHEN day_of_week = 'Thursday' THEN 4
			WHEN day_of_week = 'Friday' THEN 5
			WHEN day_of_week = 'Saturday' THEN 6
			WHEN day_of_week = 'Sunday' THEN 7
		END AS number_of_day
	FROM events_clean_update
	GROUP BY day_of_week, number_of_day, day_
)
SELECT
	day_of_week,
	ROUND(AVG(count_users)) AS avg_users
FROM cte
GROUP BY day_of_week, number_of_day
ORDER BY number_of_day;





