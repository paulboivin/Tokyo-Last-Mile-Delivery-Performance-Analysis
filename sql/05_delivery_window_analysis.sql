SELECT
    Delivery_Window,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN Delivery_Status = 'Failed'
             THEN 1 ELSE 0 END) AS failed_deliveries,
    ROUND(SUM(CASE WHEN Delivery_Status = 'Failed'
                   THEN 1.0 ELSE 0.0 END) * 100.0 /
          COUNT(*), 2) AS failure_rate_pct,
    ROUND(AVG(Delay_Minutes), 2) AS avg_delay_minutes,
    ROUND(SUM(Redelivery_Cost_JPY), 0) AS total_redelivery_cost
FROM deliveries
GROUP BY Delivery_Window
ORDER BY failure_rate_pct DESC;