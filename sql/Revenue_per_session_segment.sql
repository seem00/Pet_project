WITH cte AS (
	SELECT
		user_id,
		CASE 
			WHEN COUNT(DISTINCT user_session) = 1 THEN 'single'
			ELSE 'repeated'
		END AS activ_users	
	FROM events_clean_update
	GROUP BY user_id
	)
SELECT
	activ_users,
	COUNT(DISTINCT user_id) AS count_users,
	ROUND(SUM(price)) AS revenue
FROM events_clean_update
JOIN cte USING(user_id)
WHERE event_type = 'purchase'
GROUP BY activ_users;
	
	
	
	