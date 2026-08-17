WITH cte AS (
SELECT
	brand,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') AS uniq_count_view,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') AS uniq_count_cart
FROM events_clean_update
WHERE brand IN ('samsung', 'asus')
GROUP BY brand
)
SELECT 
	brand,
	uniq_count_view,
	uniq_count_cart,
	ROUND(uniq_count_cart * 100.0 / uniq_count_view, 2) AS conversion_to_cart
FROM cte
ORDER BY conversion_to_cart DESC;




