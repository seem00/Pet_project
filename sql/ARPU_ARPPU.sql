SELECT
	SUM(price) FILTER (WHERE event_type = 'purchase') AS revenue,
	COUNT(DISTINCT user_id) AS all_uniq_users,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'purchase') AS all_uniq_pay_users,
	ROUND(COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'purchase') * 100.0 /
		COUNT(DISTINCT user_id), 2) AS share_users,
	ROUND(SUM(price) FILTER (WHERE event_type = 'purchase') / 
		COUNT(DISTINCT user_id)) AS arpu,
	ROUND(SUM(price) FILTER (WHERE event_type = 'purchase') / 
		COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'purchase')) AS arppu
FROM events_clean_update;



SELECT
	DATE_TRUNC('month', event_time) AS month_,
	ROUND(COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'purchase') * 100.0 /
		COUNT(DISTINCT user_id), 2) AS share_users,
	ROUND(SUM(price) FILTER (WHERE event_type = 'purchase') / 
		COUNT(DISTINCT user_id)) AS arpu,
	ROUND(SUM(price) FILTER (WHERE event_type = 'purchase') / 
		COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'purchase')) AS arppu
FROM events_clean_update
WHERE DATE_TRUNC('month', event_time) >= '2020-10-01'
GROUP BY month_;




