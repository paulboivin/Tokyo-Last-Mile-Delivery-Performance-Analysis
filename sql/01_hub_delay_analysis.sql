-- Query 1: Hub Delay Analysis by Prefecture and Weather
-- Purpose: Identify which hub-prefecture-weather combinations
-- show highest average delay times
-- Business Question 1: Which hubs and time windows have highest
-- delay rates, and how do delays vary by prefecture and weather?

WITH hub_performance AS (
    -- Calculate base delay metrics per hub, prefecture, weather
    SELECT
        Origin_Hub,
        Destination_Prefecture,
        Weather_Condition,
        COUNT(*) AS delivery_count,
        ROUND(AVG(Delay_Minutes), 2) AS avg_delay_minutes,
        ROUND(AVG(CASE WHEN Delivery_Status != 'On Time' 
                       THEN 1.0 ELSE 0.0 END) * 100, 2)
            AS delay_rate_pct
    FROM deliveries
    GROUP BY Origin_Hub, Destination_Prefecture, Weather_Condition
)
SELECT
    Origin_Hub,
    Destination_Prefecture,
    Weather_Condition,
    delivery_count,
    avg_delay_minutes,
    delay_rate_pct,
    -- Rank hub-weather combinations within each prefecture
    -- by their average delay times
    DENSE_RANK() OVER (
        PARTITION BY Destination_Prefecture
        ORDER BY avg_delay_minutes DESC
    ) AS delay_rank_in_prefecture
FROM hub_performance
WHERE delivery_count >= 50
ORDER BY Destination_Prefecture, delay_rank_in_prefecture;