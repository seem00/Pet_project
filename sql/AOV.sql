SELECT
	DATE_TRUNC('month', event_time ) AS month_,
	ROUND(SUM(price) / COUNT(DISTINCT user_session)) AS aov
FROM events_clean_update
WHERE event_type = 'purchase' AND event_time  >= '2020-10-01'
GROUP BY month_
ORDER BY month_;


SELECT
	ROUND(SUM(price) / COUNT(DISTINCT user_session)) AS aov
FROM events_clean_update
WHERE event_type = 'purchase';