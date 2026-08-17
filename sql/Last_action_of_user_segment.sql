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
		LAST_VALUE(event_type) OVER (PARTITION BY user_id ORDER BY event_time 
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_action
	FROM events_clean_update
	JOIN user_segments USING(user_id)
	WHERE user_session IN (
						SELECT
							FIRST_VALUE(user_session) 
							OVER (PARTITION BY user_id  ORDER BY event_time) AS first_session
						FROM events_clean_update)
),
last_cte AS (
	SELECT
		user_segment,
		last_action,
		COUNT(*) AS count_action
	FROM cte
	GROUP BY user_segment, last_action
)
SELECT
	user_segment, 
	last_action,
	count_action,
	ROUND(count_action * 100 / SUM(count_action) 
	OVER (PARTITION BY user_segment), 2) AS share
FROM last_cte
ORDER BY user_segment, last_action;

