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
		DISTINCT user_id,
		LAST_VALUE(event_type) OVER (PARTITION BY user_session ORDER BY event_time
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_action
	FROM events_clean_update
	JOIN user_segments USING(user_id)
	WHERE user_session IN (
							SELECT
								FIRST_VALUE(user_session)
								OVER (PARTITION BY user_id ORDER BY event_time) AS first_session
							FROM events_clean_update)
	AND user_segment = 'repeated'
),
start_session AS (	
	SELECT
		user_id,
		user_session,
		MIN(DATE_TRUNC('day', event_time)) AS start_day_session
	FROM events_clean_update
	JOIN user_segments USING(user_id)
	WHERE user_segment = 'repeated'
	GROUP BY user_id, user_session
),
numbet_cte AS (
	SELECT
		user_id,
		user_session,
		ROW_NUMBER() OVER (PARTITION BY user_id  ORDER BY start_day_session) AS number_session
	FROM start_session
),
first_second_session AS (
	SELECT
		user_id,
		user_session,
		MAX(DATE_TRUNC('day', event_time)) FILTER (WHERE number_session = 1) AS first_day_session,
		MIN(DATE_TRUNC('day', event_time)) FILTER (WHERE number_session = 2) AS second_day_session
	FROM events_clean_update
	JOIN numbet_cte USING(user_id, user_session)
	GROUP BY user_id, user_session
),
all_session AS (
	SELECT
		user_id,
		MIN(second_day_session) - MAX(first_day_session) AS diff_session
	FROM first_second_session
	WHERE user_id IN (SELECT
						DISTINCT user_id
					FROM events_clean_update
					JOIN cte USING(user_id)
					WHERE last_action = 'view')
	GROUP BY user_id
UNION
	SELECT
		user_id,
		MIN(second_day_session) - MAX(first_day_session) AS diff_session
	FROM first_second_session
	WHERE user_id IN (SELECT
						DISTINCT user_id
					FROM events_clean_update
					JOIN cte USING(user_id)
					WHERE last_action = 'cart')
	GROUP BY user_id
UNION
	SELECT
		user_id,
		MIN(second_day_session) - MAX(first_day_session) AS diff_session
	FROM first_second_session
	WHERE user_id IN (SELECT
						DISTINCT user_id
					FROM events_clean_update
					JOIN cte USING(user_id)
					WHERE last_action = 'purchase')
	GROUP BY user_id
)
SELECT
	last_action,
	DATE_TRUNC('day', AVG(diff_session)) AS avg_time_back,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY diff_session) AS median_time_back
FROM all_session
JOIN cte USING (user_id)
WHERE diff_session > '0 seconds'::interval
GROUP BY last_action;


