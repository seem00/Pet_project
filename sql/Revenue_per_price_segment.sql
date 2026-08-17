SELECT
	price_segment,
	ROUND(SUM(price)) AS revenue
FROM events_clean_update
WHERE event_type = 'purchase'
GROUP BY price_segment
ORDER BY revenue DESC;
	
	
	
	