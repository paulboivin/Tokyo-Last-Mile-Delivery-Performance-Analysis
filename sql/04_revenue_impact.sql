-- Query 4: Combined Revenue Impact by Hub
-- Purpose: Quantifies financial impact of delivery failures
-- and SLA penalties by origin hub and weather
-- Business Question 4: What is the combined revenue impact of
-- redelivery costs and SLA penalties by hub?

WITH revenue_breakdown AS (
    -- Calculate revenue impact components per hub
    SELECT
        Origin_Hub,
        COUNT(*) AS total_deliveries,
        SUM(CASE WHEN Delivery_Status = 'Failed' 
                 THEN 1 ELSE 0 END) AS failed_deliveries,
        SUM(CASE WHEN Delay_Minutes > 60 
                 THEN 1 ELSE 0 END) AS sla_breaches,
        SUM(Redelivery_Cost_JPY) AS total_redelivery_cost,
        SUM(SLA_Penalty_JPY) AS total_sla_penalty,
        SUM(Total_Revenue_Impact_JPY) AS total_revenue_impact,
        -- Calculate per-attempt redelivery costs more precisely
        -- Higher attempt numbers compound cost
        SUM(CASE WHEN Delivery_Status = 'Failed' 
                 THEN Delivery_Attempt_Number * 800 
                 ELSE 0 END) AS attempt_weighted_redelivery_cost
    FROM deliveries
    GROUP BY Origin_Hub
)
SELECT
    Origin_Hub,
    total_deliveries,
    failed_deliveries,
    sla_breaches,
    ROUND(failed_deliveries * 100.0 / 
          total_deliveries, 2) AS failure_rate_pct,
    ROUND(sla_breaches * 100.0 / 
          total_deliveries, 2) AS sla_breach_rate_pct,
    total_redelivery_cost,
    total_sla_penalty,
    total_revenue_impact,
    attempt_weighted_redelivery_cost,
    -- Calculate additional cost from multi-attempt failures
    attempt_weighted_redelivery_cost - 
        total_redelivery_cost AS additional_multi_attempt_cost,
    -- Each hub's share of total revenue impact
    ROUND(total_revenue_impact * 100.0 / 
          SUM(total_revenue_impact) OVER (), 2) AS pct_of_total_impact
FROM revenue_breakdown
ORDER BY total_revenue_impact DESC;