SELECT
	DATE_TRUNC('month', event_time) AS month_,
	category_lvl_1,
	SUM(price) AS revenue
FROM events_clean_update
WHERE event_type = 'purchase'
	AND DATE_TRUNC('month', event_time) IN ('2020-10-01', '2021-01-01')
	AND category_lvl_1 IN 
		('computers', 
		'electronics', 
		'appliances', 
		'stationery', 
		'auto',
		'construction')
GROUP BY month_, category_lvl_1
ORDER BY month_, category_lvl_1;