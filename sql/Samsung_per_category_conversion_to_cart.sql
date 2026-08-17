SELECT
	category_code,
	price_segment,
	COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') AS uniq_count_view,
    COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') AS uniq_count_cart,
    ROUND(COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') * 100.0 /
        COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view'), 2) AS conversion_to_cart
FROM events_clean_update
WHERE category_code IN (
	SELECT
	category_code
	FROM events_clean_update
	WHERE product_id IN (
		SELECT
			DISTINCT product_id 
		FROM events_clean_update
		WHERE brand = 'samsung'
		)
		AND category_code IS NOT NULL
	GROUP BY category_code
	HAVING COUNT(DISTINCT product_id) > 1
	)
	AND brand = 'samsung'
	AND price_segment = 'expensive'
	GROUP BY category_code, price_segment
	ORDER BY conversion_to_cart DESC;





