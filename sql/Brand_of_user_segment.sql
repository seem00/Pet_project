WITH user_segments AS (
	SELECT
		user_id,
		CASE
			WHEN COUNT(DISTINCT user_session) = 1 THEN 'single'
			WHEN COUNT(DISTINCT user_session) >= 2 THEN 'repeated'
		END AS user_segment
	FROM events_clean_update
	GROUP BY user_id
),
cte AS (
	SELECT
		user_segment,
		brand,
		COUNT(DISTINCT user_id) AS count_users
	FROM events_clean_update
	JOIN user_segments USING(user_id)
	WHERE user_session IN (
							SELECT
								FIRST_VALUE(user_session)
								OVER (PARTITION BY user_id ORDER BY event_time) AS first_session
							FROM events_clean_update)
	AND category_code IN ('computers.components.videocards')
	AND brand IS NOT NULL
	GROUP BY user_segment, brand
)
SELECT
	user_segment,
	brand,
	ROUND(count_users * 100 / SUM(count_users)
	OVER(PARTITION BY user_segment), 2) AS share
FROM cte
ORDER BY user_segment, brand;




