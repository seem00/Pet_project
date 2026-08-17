SELECT
	COUNT(*) AS count_buy_per_users
FROM events_clean_update
WHERE category_code  = 'computers.components.videocards'
	AND DATE_TRUNC('month', event_time) = '2021-01-01'
	AND event_type = 'purchase'
GROUP BY user_id
ORDER BY count_buy_per_users DESC;
	
	
	
	