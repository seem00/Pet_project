WITH dau_df AS (
SELECT
	DATE_TRUNC('day', event_time) AS date_day,
	COUNT(DISTINCT user_id) AS dau
FROM events_clean_update
GROUP BY date_day
),
avg_dau_df AS (SELECT
	DATE_TRUNC('month', date_day) AS date_month,
	AVG(dau) AS avg_dau
FROM dau_df
WHERE date_day >= '2020-10-01'
GROUP BY date_month
),
mau_df AS (SELECT 
	DATE_TRUNC('month', event_time) AS date_month,
	COUNT(DISTINCT user_id) AS mau
FROM events_clean_update
WHERE event_time >= '2020-10-01'
GROUP BY date_month
)
SELECT
	date_month,
	ROUND(avg_dau / mau * 100, 2) AS stickiness 
FROM mau_df
JOIN avg_dau_df using(date_month)
ORDER BY date_month;






