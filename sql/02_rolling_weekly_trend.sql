-- Query 2: Rolling Weekly Delay Trend Analysis
-- Purpose: Tracks week over week change in delivery delays
-- to determine whether performance is improving or worsening
-- Business Question 2: What is the rolling week over week trend
-- in delivery delays?

WITH weekly_metrics AS (
    -- Aggregate delivery metrics by ISO week number
    -- strftime '%W' returns the ISO week number (00-53)
    SELECT
        strftime('%W', Scheduled_Delivery_DateTime) AS week_number,
        MIN(DATE(Scheduled_Delivery_DateTime)) AS week_start_date,
        COUNT(*) AS total_deliveries,
        ROUND(AVG(Delay_Minutes), 2) AS avg_delay_minutes,
        ROUND(AVG(CASE WHEN Delivery_Status != 'On Time' 
                       THEN 1.0 ELSE 0.0 END) * 100, 2)
            AS delay_rate_pct,
        SUM(CASE WHEN Delivery_Status = 'Failed' 
                 THEN 1 ELSE 0 END) AS failed_deliveries
    FROM deliveries
    GROUP BY week_number
)
SELECT
    week_number,
    week_start_date,
    total_deliveries,
    avg_delay_minutes,
    delay_rate_pct,
    failed_deliveries,
    -- Previous week's average delay using LAG
    LAG(avg_delay_minutes, 1) OVER (
        ORDER BY week_number
    ) AS prev_week_avg_delay,
    -- Week over week change in average delay minutes
    ROUND(avg_delay_minutes - 
          LAG(avg_delay_minutes, 1) OVER (
              ORDER BY week_number
          ), 2) AS wow_delay_change,
    -- Week over week percentage change
    ROUND((avg_delay_minutes - 
           LAG(avg_delay_minutes, 1) OVER (
               ORDER BY week_number
           )) * 100.0 / 
           LAG(avg_delay_minutes, 1) OVER (
               ORDER BY week_number
           ), 2) AS wow_delay_pct_change
FROM weekly_metrics
ORDER BY week_number;