SELECT
	category_code,
	ROUND(SUM(price)) AS revenue
FROM events_clean_update
WHERE event_type = 'purchase' AND category_code IS NOT NULL
GROUP BY category_code
ORDER BY revenue DESC
LIMIT 10;



