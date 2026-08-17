WITH cte AS (
SELECT
	COUNT(distinct user_id) FILTER(where event_type = 'view') as uniq_count_view,
	COUNT(distinct user_id) FILTER(where event_type = 'cart') as uniq_count_cart,
	COUNT(distinct user_id) FILTER(where event_type = 'purchase') as uniq_count_purchase
FROM events_clean_update
)
SELECT 
	uniq_count_view,
	uniq_count_cart,
	uniq_count_purchase,
	ROUND(uniq_count_view * 100.0 / uniq_count_view, 2) AS start_share,
	ROUND(uniq_count_purchase * 100.0 / uniq_count_view, 2) AS general_conversion,
	ROUND(uniq_count_cart * 100.0 / uniq_count_view, 2) AS conversion_to_cart,
	ROUND(uniq_count_purchase * 100.0 / uniq_count_cart, 2) AS conversion_to_purchase
FROM cte;






