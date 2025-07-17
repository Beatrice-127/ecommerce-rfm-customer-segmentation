/*
===============================================================================
02 - Order Time Analysis
===============================================================================
Purpose:
    - Explore the time range of the dataset
    - Analyze monthly order volume over time
    - Create a derived table `order_time` with detailed time features for later use

Tables Used:
    - olist_data

SQL Functions Used:
    - MIN(), MAX(), AGE(), EXTRACT(), TO_CHAR(), DATE

Output:
    - Summary: first and last order date, total duration
    - Monthly order count
    - order_time table (with year/quarter/month/day/hour fields)
===============================================================================
*/

-- Order range: first and last purchase timestamp, duration in days and months
SELECT
    MIN(order_purchase_timestamp) AS min_time,
    MAX(order_purchase_timestamp) AS max_time,
    (MAX(order_purchase_timestamp)::date - MIN(order_purchase_timestamp)::date) AS order_range_days,
    EXTRACT(YEAR FROM AGE(MAX(order_purchase_timestamp), MIN(order_purchase_timestamp))) * 12 +
    EXTRACT(MONTH FROM AGE(MAX(order_purchase_timestamp), MIN(order_purchase_timestamp))) AS order_range_months
FROM olist_data;

-- Monthly order volume (number of orders per calendar month)
SELECT 
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS month,
    COUNT(DISTINCT order_id) AS order_count
FROM olist_data
GROUP BY month
ORDER BY month;

-- Create a time-dimension table for each order (filtering out outlier months)
CREATE TABLE order_time AS
SELECT 
    order_id,
    customer_id,
    customer_unique_id,
    EXTRACT(YEAR FROM order_purchase_timestamp) AS y,
    EXTRACT(QUARTER FROM order_purchase_timestamp) AS q,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS m,
    DATE(order_purchase_timestamp) AS d,
    EXTRACT(HOUR FROM order_purchase_timestamp) AS h
FROM olist_data
WHERE TO_CHAR(order_purchase_timestamp, 'YYYY-MM') NOT IN (
    '2016-09', '2016-12', '2018-09', '2018-10'
);
