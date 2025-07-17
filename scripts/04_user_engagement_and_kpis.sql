/*
===============================================================================
04 - User Engagement & Business KPIs
===============================================================================
Purpose:
    - Analyze user activity over time (DAU, MAU, HAU)
    - Compute business metrics such as GMV and ARPU by different time units
    - Identify order distribution trends across hours or periods

Table Used:
    - order_time_and_value (created from previous steps)

SQL Functions Used:
    - COUNT(), DISTINCT, SUM(), ROUND(), TO_CHAR(), EXTRACT(), GROUP BY

Output:
    - Daily/Monthly/Quarterly KPIs including:
        • DAU, MAU, HAU
        • Hourly order counts
        • GMV (Gross Merchandise Volume)
        • ARPU (Average Revenue Per User)
===============================================================================
*/

-- Daily Active Users (DAU)
SELECT 
    d AS date,
    COUNT(customer_unique_id) AS dau 
FROM order_time_and_value
GROUP BY d
ORDER BY d;

-- Monthly Active Users (MAU)
SELECT 
    TO_CHAR(d, 'YYYY-MM') AS month,
    COUNT(DISTINCT customer_unique_id) AS mau
FROM order_time_and_value
GROUP BY month
ORDER BY month;

-- Hourly Active Users (HAU)
SELECT 
    h AS hour,
    COUNT(DISTINCT customer_unique_id) AS hau
FROM order_time_and_value
GROUP BY h
ORDER BY hour;

-- Orders per hour
SELECT 
    h AS hour,
    COUNT(order_id) AS orders_per_hour
FROM order_time_and_value
GROUP BY h
ORDER BY hour;

-- Quarterly GMV
SELECT
    TO_CHAR(d, 'YYYY') || '-Q' || EXTRACT(QUARTER FROM d) AS year_quarter,
    SUM(total_order_value) AS quarter_gmv
FROM order_time_and_value
GROUP BY year_quarter
ORDER BY year_quarter;

-- Monthly GMV
SELECT 
    TO_CHAR(d, 'YYYY-MM') AS month,
    SUM(total_order_value) AS monthly_gmv
FROM order_time_and_value
GROUP BY month
ORDER BY month;

-- Quarterly ARPU
SELECT 
    TO_CHAR(d, 'YYYY') || '-Q' || EXTRACT(QUARTER FROM d) AS year_quarter,
    ROUND(SUM(total_order_value) / COUNT(customer_unique_id), 2) AS quarterly_arpu
FROM order_time_and_value
GROUP BY year_quarter
ORDER BY year_quarter;

-- Daily ARPU
SELECT 
    d AS date,
    ROUND(SUM(total_order_value) / COUNT(customer_unique_id), 2) AS daily_arpu
FROM order_time_and_value
GROUP BY d
ORDER BY d;
