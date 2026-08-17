SELECT
	category_code,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') AS uniq_count_view,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') AS uniq_count_cart,
	ROUND(COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') * 100.0 /
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view'), 2) AS conversion_to_cart
FROM events_clean_update
WHERE category_lvl_1 = 'appliances'
GROUP BY category_code
HAVING COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') > 1000
ORDER BY conversion_to_cart DESC;




