WITH cte_session AS (
SELECT
	user_id,
	COUNT(DISTINCT user_session) AS count_session
FROM events_clean_update
GROUP BY user_id
),
cte_segment AS (
SELECT
	user_id,
	CASE WHEN count_session = 1 THEN 'single'
	ELSE 'repeated'
	END AS session_segment
FROM cte_session
),
cte AS (
SELECT
	session_segment,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') AS uniq_count_view,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') AS uniq_count_cart
FROM events_clean_update
JOIN cte_segment using(user_id)
GROUP BY session_segment
)
SELECT 
	session_segment,
	uniq_count_view,
	uniq_count_cart,
	ROUND(uniq_count_cart * 100.0 / uniq_count_view, 2) AS conversion_to_cart
FROM cte
ORDER BY conversion_to_cart DESC;




