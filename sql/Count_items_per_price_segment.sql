SELECT
	price_segment,
	COUNT(*) AS count_items
FROM events_clean_update
WHERE event_type = 'purchase'
GROUP BY price_segment;


