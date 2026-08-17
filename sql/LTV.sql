WITH buy AS (
	SELECT
		user_id,
		FIRST_VALUE(DATE_TRUNC('month', event_time)) 
		OVER (PARTITION BY user_id ORDER BY event_time) AS month_purchase
	FROM events_clean_update
		WHERE event_type = 'purchase'
),
cohort_cte AS (
	SELECT
		user_id,
		CASE 
			WHEN month_purchase = '2020-10-01' THEN 'oct'
			WHEN month_purchase = '2020-11-01' THEN 'nov'
			WHEN month_purchase = '2020-12-01' THEN 'dec'
			WHEN month_purchase = '2021-01-01' THEN 'jan'
			WHEN month_purchase = '2021-02-01' THEN 'feb'
			ELSE 'no_cohort'
		END AS cohort_month
	FROM buy
),
size_cohort AS (
	SELECT 
		cohort_month,
		COUNT(DISTINCT user_id) AS uniq_users
	FROM events_clean_update
	JOIN cohort_cte USING(user_id)
	WHERE cohort_month <> 'no_cohort'
	GROUP BY cohort_month
),
revenue_cte AS (
	SELECT 
		cohort_month,
		DATE_TRUNC('month', event_time) AS month_,
		SUM(price) AS revenue
	FROM events_clean_update
	JOIN cohort_cte USING(user_id)
	WHERE cohort_month <> 'no_cohort' AND event_type = 'purchase'
	GROUP BY cohort_month, month_
	ORDER BY cohort_month, month_
),
cte AS (
	SELECT
		cohort_month,
		month_,
		revenue,
		SUM(revenue) OVER (PARTITION BY cohort_month ORDER BY month_) AS cum_revenue
	FROM revenue_cte
)
SELECT 
	cohort_month,
	month_,
	revenue,
	cum_revenue,
	uniq_users,
	ROUND(cum_revenue / uniq_users) AS ltv
FROM cte 
JOIN size_cohort USING(cohort_month)
ORDER BY cohort_month, month_;








