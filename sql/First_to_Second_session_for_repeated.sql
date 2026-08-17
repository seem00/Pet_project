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
cte_start_session AS (
	SELECT
		user_id,
		user_session,
		MIN(DATE_TRUNC('day', event_time)) AS day_start_session
	FROM events_clean_update
	JOIN user_segments USING(user_id)
	WHERE user_segment = 'repeated'
	GROUP BY user_id, user_session
),
cte_number AS (
	SELECT 
		user_id,
		user_session,
		ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY day_start_session) AS number_session
	FROM cte_start_session
),
cte_type AS (
	SELECT
		user_id,
		user_session,
		number_session,
		CASE
			WHEN MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 1 THEN 'purchase'
			WHEN MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) = 1 THEN 'cart'
			ELSE 'view'
		END AS type_session
	FROM events_clean_update
	JOIN cte_number USING(user_id, user_session)
	WHERE number_session IN (1,2)
	GROUP BY user_id, user_session, number_session
),
final_cte AS (
	SELECT
		user_id,
		user_session,
		number_session,
		CASE 
			WHEN number_session = 1 THEN type_session
		END AS first_session,
		CASE 
			WHEN number_session = 2 THEN type_session
		END AS second_session
	FROM cte_type
),
last_cte AS (
	SELECT 
		user_id,
		MAX(first_session) AS firsts_session,
		MAX(second_session) AS seconds_session
	FROM final_cte
	GROUP BY user_id
),
cte AS (
	SELECT
		firsts_session,
		seconds_session,
		COUNT(*) AS count_events
	FROM last_cte
	GROUP BY firsts_session, seconds_session
)
SELECT
	firsts_session,
	seconds_session,
	count_events,
	ROUND(count_events * 100.0 / 
	SUM(count_events) OVER (PARTITION BY firsts_session), 2) AS share
FROM cte
ORDER BY firsts_session, seconds_session;










