SELECT
	price_segment,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') AS uniq_count_view,
    COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') AS uniq_count_cart,
    ROUND(COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') * 100.0 /
        COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view'), 2) AS conversion_to_cart
FROM events_clean_update
WHERE brand = 'samsung'
GROUP BY price_segment;