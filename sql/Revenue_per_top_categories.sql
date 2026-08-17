SELECT
	category_lvl_1,
	ROUND(SUM(price)) AS revenue
FROM events_clean_update
WHERE event_type = 'purchase'
	AND category_lvl_1 IN (
		'computers', 
		'electronics',
		'appliances',
		'stationery',
		'auto',
        'construction')
GROUP BY category_lvl_1;



