WITH user_segments AS (
    SELECT
        user_id,
        CASE
            WHEN COUNT(DISTINCT user_session) = 1 THEN 'single'
            WHEN COUNT(DISTINCT user_session) >= 2 THEN 'repeated'
        END AS user_segment
    FROM events_clean_update
    GROUP BY user_id
)
SELECT
    user_segment,
    ROUND(SUM(price) / COUNT(DISTINCT user_session)) AS aov
FROM events_clean_update
JOIN user_segments USING(user_id)
WHERE event_type = 'purchase'
GROUP BY user_segment
ORDER BY aov DESC;