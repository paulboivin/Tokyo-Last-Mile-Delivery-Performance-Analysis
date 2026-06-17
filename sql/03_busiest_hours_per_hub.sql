-- Query 3: Busiest Hours Per Hub and Delay Correlation
-- Purpose: Identifies top 3 busiest hours for each hub
-- and examines whether peak volume correlates with delays
-- Business Question 3: Which hours are busiest per hub and
-- does peak volume correlate with higher delay rates?

WITH hourly_hub_metrics AS (
    -- Extract delivery hour and aggregate by hub
    SELECT
        Origin_Hub,
        CAST(strftime('%H', Scheduled_Delivery_DateTime) 
             AS INTEGER) AS delivery_hour,
        COUNT(*) AS deliveries_count,
        ROUND(AVG(Delay_Minutes), 2) AS avg_delay_minutes,
        ROUND(AVG(CASE WHEN Delivery_Status != 'On Time' 
                       THEN 1.0 ELSE 0.0 END) * 100, 2)
            AS delay_rate_pct,
        SUM(CASE WHEN Delivery_Status = 'Failed'
                 THEN 1 ELSE 0 END) AS failed_count
    FROM deliveries
    GROUP BY Origin_Hub, delivery_hour
),
ranked_hours AS (
    -- Rank hours within each hub by delivery volume
    SELECT
        Origin_Hub,
        delivery_hour,
        deliveries_count,
        avg_delay_minutes,
        delay_rate_pct,
        failed_count,
        ROW_NUMBER() OVER (
            PARTITION BY Origin_Hub
            ORDER BY deliveries_count DESC
        ) AS volume_rank
    FROM hourly_hub_metrics
)
SELECT
    Origin_Hub,
    delivery_hour,
    deliveries_count,
    avg_delay_minutes,
    delay_rate_pct,
    failed_count,
    volume_rank
FROM ranked_hours
WHERE volume_rank <= 3
ORDER BY Origin_Hub, volume_rank;