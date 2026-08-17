SELECT
	DATE_TRUNC('month', event_time) AS month_,
	category_code,
	ROUND(SUM(price)) AS revenue
FROM events_clean_update
WHERE category_code  = 'computers.components.videocards'
	AND DATE_TRUNC('month', event_time) IN ('2020-10-01', '2021-01-01')
	AND event_type = 'purchase'
GROUP BY month_, category_code
ORDER BY month_, category_code;
