SELECT
	category_lvl_1,
	COUNT(product_id) AS count_items,
	COUNT(DISTINCT user_id) AS count_users,
	ROUND(SUM(price)) AS revenue,
	ROUND(COUNT(product_id) * 1.0 / COUNT(DISTINCT user_id), 2) AS items_per_user,
	ROUND(SUM(price) / COUNT(DISTINCT user_id)) AS arppu
FROM events_clean_update
WHERE category_lvl_1  IN (
	'computers',
	'electronics',
	'appliances',
	'stationery',
	'auto',
	'construction')
	AND event_type = 'purchase'
GROUP BY category_lvl_1
ORDER BY arppu DESC;






