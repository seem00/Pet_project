WITH cte AS (
SELECT
	category_lvl_1,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') AS uniq_count_view,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') AS uniq_count_cart
FROM events_clean_update
WHERE category_lvl_1 IN 
('computers', 'electronics', 'appliances', 'stationery', 'auto', 'construction')
GROUP BY category_lvl_1
)
SELECT 
	category_lvl_1,
	uniq_count_view,
	uniq_count_cart,
	ROUND(uniq_count_cart * 100.0 / uniq_count_view, 2) AS conversion_to_cart
FROM cte
ORDER BY conversion_to_cart DESC;




