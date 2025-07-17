/*
===============================================================================
05 - RFM Scoring
===============================================================================
Purpose:
    - Construct Recency, Frequency, and Monetary (RFM) values for each user
    - Explore and validate RFM distributions
    - Build scoring tables using both quantiles and custom logic

Tables Used:
    - order_time_and_value
    - customer_total_value

Views Created:
    - rfm_recency
    - rfm_frequency
    - rfm_monetary
    - rfm_base
    - rfm_scored
    - rfm_scored_custom

SQL Functions Used:
    - MAX(), COUNT(), SUM(), ROUND(), NTILE(), PERCENTILE_DISC(), COALESCE()
===============================================================================
*/

-- Recency: Days since last order
CREATE VIEW rfm_recency AS
WITH max_date AS (
    SELECT MAX(d) AS max_d FROM order_time_and_value
),
last_order AS (
    SELECT 
        customer_unique_id,
        MAX(d) AS last_order_date
    FROM order_time_and_value
    GROUP BY customer_unique_id
)
SELECT 
    l.customer_unique_id,
    (m.max_d - l.last_order_date) AS recency
FROM last_order l, max_date m;

-- Frequency: Number of orders
CREATE VIEW rfm_frequency AS
SELECT
    customer_unique_id,
    total_orders AS frequency
FROM customer_total_value;

-- Monetary: Total spending
CREATE VIEW rfm_monetary AS
SELECT 
    customer_unique_id,
    ROUND(total_spent::numeric, 2) AS monetary
FROM customer_total_value;

-- Base RFM table
CREATE VIEW rfm_base AS
SELECT
    r.customer_unique_id,
    r.recency,
    f.frequency,
    m.monetary
FROM rfm_recency r
JOIN rfm_frequency f ON r.customer_unique_id = f.customer_unique_id
JOIN rfm_monetary m ON r.customer_unique_id = m.customer_unique_id;

-- Initial RFM scoring using NTILE(5)
CREATE VIEW rfm_scored AS
WITH ranked AS (
    SELECT 
        customer_unique_id,
        recency,
        frequency,
        monetary,
        6 - NTILE(5) OVER (ORDER BY recency) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM rfm_base
)
SELECT 
    *,
    CAST(r_score AS TEXT) || CAST(f_score AS TEXT) || CAST(m_score AS TEXT) AS rfm_string_score,
    r_score + f_score + m_score AS rfm_total_score
FROM ranked;

-- Custom RFM scoring (balanced by real distributions)
CREATE OR REPLACE VIEW rfm_scored_custom AS
SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,

    -- Recency: 3 = most recent
    4 - NTILE(3) OVER (ORDER BY recency) AS r_score,

    -- Frequency: custom segmentation
    CASE
        WHEN frequency = 1 THEN 1
        WHEN frequency = 2 THEN 2
        ELSE 3
    END AS f_score,

    -- Monetary: based on spending thresholds
    CASE
        WHEN COALESCE(monetary, 0) < 100 THEN 1
        WHEN COALESCE(monetary, 0) < 500 THEN 2
        ELSE 3
    END AS m_score,

    -- String and total score
    CAST((4 - NTILE(3) OVER (ORDER BY recency)) AS TEXT)
    || CAST(CASE WHEN frequency = 1 THEN 1 WHEN frequency = 2 THEN 2 ELSE 3 END AS TEXT)
    || CAST(CASE WHEN COALESCE(monetary, 0) < 100 THEN 1 WHEN COALESCE(monetary, 0) < 500 THEN 2 ELSE 3 END AS TEXT)
    AS rfm_string_score,

    (
        (4 - NTILE(3) OVER (ORDER BY recency)) +
        CASE WHEN frequency = 1 THEN 1 WHEN frequency = 2 THEN 2 ELSE 3 END +
        CASE WHEN COALESCE(monetary, 0) < 100 THEN 1 WHEN COALESCE(monetary, 0) < 500 THEN 2 ELSE 3 END
    ) AS rfm_total_score

FROM rfm_base;
