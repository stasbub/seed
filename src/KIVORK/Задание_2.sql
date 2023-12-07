-- Задача 1

SELECT
    SUM(sale_amount) / COUNT(id) AS avg
FROM orders

WITH total_count AS (
    SELECT
        id,
        sale_amount,
        COUNT(*) OVER (ORDER BY sale_amount) AS cumulative_count,
        COUNT(*) OVER () AS total_rows
    FROM orders
)
SELECT
    sale_amount AS median
FROM total_count
WHERE cumulative_count = ROUND((total_rows / 2), 0)

-- Задача 2

WITH add_row_num AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY transaction_id) AS row_num
    FROM purchases
)
SELECT
    transaction_id,
    datetime,
    amount,
    user_id
FROM add_row_num
WHERE row_num = 2

-- Задача 3

WITH funnel_cte AS (
    SELECT
        country,
        COUNT(DISTINCT CASE WHEN event_type = 'instal' THEN user_id END) AS installs,
        COUNT(DISTINCT CASE WHEN event_type = 'trial' THEN user_id END) AS trials,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases,
    FROM events
    GROUP BY
        country
)
SELECT
    country,
    installs,
    trials,
    purchases,
    CASE
        WHEN installs > 0 THEN trials * 100.0 / installs ELSE 0 
    END AS conversion_rate_to_trial,
    CASE
        WHEN trials > 0 THEN purchases * 100.0 / trials ELSE 0
    END AS conversion_rate_to_purchase
FROM
    funnel_cte;
