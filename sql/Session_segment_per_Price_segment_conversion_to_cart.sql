WITH user_segments AS (
    SELECT
        user_id,
        CASE
            WHEN COUNT(DISTINCT user_session) = 1 THEN 'single'
            ELSE 'repeated'
        END AS session_segment
    FROM events_clean_update
    GROUP BY user_id
)
SELECT 
    session_segment,
    price_segment,
    COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') AS uniq_count_view,
    COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') AS uniq_count_cart,
    ROUND(COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') * 100.0 /
        COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view'), 2) AS conversion_to_cart
FROM events_clean_update
JOIN user_segments USING (user_id)
GROUP BY session_segment, price_segment
ORDER BY session_segment, price_segment;