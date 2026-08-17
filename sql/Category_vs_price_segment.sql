WITH cte AS (
	SELECT
		category_lvl_1,
		price_segment,
		COUNT(product_id) AS count_sell_items,
		ROUND(SUM(price)) AS revenue
	FROM events_clean_update
	WHERE category_lvl_1 IN 
		('computers', 
		'electronics', 
		'stationery',
		'appliances',
		'auto',
		'construction')
		AND event_type = 'purchase'
	GROUP BY category_lvl_1, price_segment
)
SELECT 
	category_lvl_1,
	price_segment,
	count_sell_items,
	revenue,
	ROUND(count_sell_items * 100.0 / 
	SUM(count_sell_items) OVER (PARTITION BY category_lvl_1), 2) AS share_sell,
	ROUND(revenue::numeric * 100.0 / 
	SUM(revenue) OVER (PARTITION BY category_lvl_1)::numeric, 2) AS share_revenue
FROM cte
ORDER BY category_lvl_1, price_segment;








