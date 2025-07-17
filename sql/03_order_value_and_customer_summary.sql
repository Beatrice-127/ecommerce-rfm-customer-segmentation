/*
===============================================================================
03 - Order Value & Customer Summary
===============================================================================
Purpose:
    - Calculate total product value, freight, and total order value per order
    - Join customer information to associate orders with users
    - Create customer-level summary of total spend and order count
    - Join time and value information into one unified view

Tables Used:
    - olist_data
    - order_time (from previous step)

Views Created:
    - order_total_summary
    - order_with_customer_summary
    - customer_total_value
    - order_time_and_value

SQL Functions Used:
    - SUM(), COUNT(), ROUND(), DISTINCT, JOIN
===============================================================================
*/

-- Calculate order-level total product value, freight, and full order value
CREATE VIEW order_total_summary AS
SELECT
    order_id,
    SUM(price) AS total_product_value,
    SUM(freight_value) AS total_freight,
    SUM(price + freight_value) AS total_order_value
FROM olist_data
GROUP BY order_id;

-- Join with customer info (customer_id, customer_unique_id)
CREATE VIEW order_with_customer_summary AS
SELECT
    o.order_id,
    d.customer_id,
    d.customer_unique_id,
    o.total_product_value,
    o.total_freight,
    o.total_order_value
FROM order_total_summary o
JOIN (
    SELECT DISTINCT order_id, customer_id, customer_unique_id
    FROM olist_data
) d ON o.order_id = d.order_id;

-- Customer-level summary: total orders, total spent, total freight paid
CREATE VIEW customer_total_value AS
SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_order_value) AS total_spent,
    SUM(total_freight) AS total_freight_paid
FROM order_with_customer_summary
GROUP BY customer_unique_id
ORDER BY total_spent DESC;

-- Combine time and value features per order
CREATE VIEW order_time_and_value AS
SELECT
    a.order_id,
    a.customer_id,
    a.customer_unique_id,
    ROUND(a.total_order_value::numeric, 2) AS total_order_value,
    b.y,
    b.q,
    b.m,
    b.d,
    b.h
FROM order_with_customer_summary a
JOIN order_time b
  ON a.order_id = b.order_id;
