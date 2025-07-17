/*
===============================================================================
99 - Data Quality Checks: Dropped Orders
===============================================================================
Purpose:
    - To identify if any orders were excluded from the constructed views
    - To verify whether dropped orders are due to explicit filtering (e.g. outlier months)

Tables Used:
    - olist_data
    - order_time_and_value

SQL Functions Used:
    - LEFT JOIN, TO_CHAR(), DISTINCT, IN

Remarks:
    - The dropped orders were intentionally filtered out based on known outlier months.
===============================================================================
*/

-- Check if any orders in olist_data were dropped after joining with order_time_and_value
SELECT DISTINCT o.order_id
FROM olist_data o
LEFT JOIN order_time_and_value v ON o.order_id = v.order_id
WHERE v.order_id IS NULL;

-- Confirm if these dropped orders are due to date filtering
SELECT DISTINCT order_id
FROM olist_data
WHERE TO_CHAR(order_purchase_timestamp, 'YYYY-MM') NOT IN (
  '2016-09', '2016-12', '2018-09', '2018-10'
)
AND order_id IN (
  SELECT DISTINCT o.order_id
  FROM olist_data o
  LEFT JOIN order_time_and_value v ON o.order_id = v.order_id
  WHERE v.order_id IS NULL
);