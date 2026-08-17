WITH cohort_cte AS (
	SELECT
		user_id,
		FIRST_VALUE(DATE_TRUNC('month', event_time)) 
		OVER (PARTITION BY user_id ORDER BY event_time) AS cohort_month
	FROM events_clean_update
		WHERE event_type = 'purchase'
),
cte AS (
	SELECT
		cohort_month,
		DATE_TRUNC('month', event_time) AS month_,
		COUNT(DISTINCT user_id) AS uniq_count_users
	FROM events_clean_update
	JOIN cohort_cte USING(user_id)
	WHERE cohort_month >= '2020-10-01' AND event_time >= '2020-10-01'
	GROUP BY cohort_month, month_
)
SELECT
	cohort_month,
	month_,
	uniq_count_users,
	ROUND(uniq_count_users * 100.0 / 
	MAX(uniq_count_users) OVER (PARTITION BY cohort_month), 2) AS share
FROM cte 
WHERE cohort_month <= month_;








