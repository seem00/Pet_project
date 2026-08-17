SELECT
	DATE_TRUNC('month', event_time) AS month_,
	brand,
	ROUND(SUM(price)) AS revenue
FROM events_clean_update
WHERE category_code  = 'computers.components.videocards'
	AND event_type = 'purchase'
	AND DATE_TRUNC('month', event_time) IN ('2020-10-01', '2021-01-01')
	AND brand IS NOT NULL
GROUP BY month_, brand
ORDER BY revenue;
	
	
	
	