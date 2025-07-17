/*
===============================================================================
06 - RFM Labeling and Quality Checks
===============================================================================
Purpose:
    - Assign customer segments based on RFM scores using business rules
    - Investigate anomalies in RFM scoring (e.g., NULL values, skewed distributions)
    - Summarize value distributions to validate scoring logic

Tables Used:
    - rfm_scored_custom
    - rfm_base
    - rfm_monetary
    - olist_data

SQL Functions Used:
    - CASE, COALESCE, COUNT(), FILTER(), JOIN, PERCENTILE_DISC()
===============================================================================
*/

-- Label customers based on custom RFM scores
CREATE TABLE rfm_scored_labeled AS
SELECT
    *,
    CASE
        WHEN r_score = 3 AND f_score = 3 AND m_score = 3 THEN 'Champion'
        WHEN r_score = 3 AND f_score >= 2 THEN 'Loyal Customer'
        WHEN r_score = 3 AND f_score = 1 THEN 'Recent Buyer'
        WHEN r_score = 2 AND f_score >= 2 THEN 'Potential Loyalist'
        WHEN r_score = 1 AND f_score >= 2 THEN 'At Risk'
        WHEN f_score = 3 AND m_score = 1 THEN 'Frequent but Low-Value'
        ELSE 'Others'
    END AS rfm_label
FROM rfm_scored_custom;

-- Check how many customers have NULL monetary value
SELECT
    COUNT(*) AS count_of_null_monetary
FROM rfm_monetary
WHERE monetary IS NULL;

-- Investigate the order statuses associated with NULL monetary users
SELECT
    a.order_status,
    COUNT(*) AS order_count
FROM olist_data a
JOIN rfm_base b
  ON a.customer_unique_id = b.customer_unique_id
WHERE b.monetary IS NULL
GROUP BY a.order_status
ORDER BY order_count DESC;

-- Summary of monetary value distribution (simple buckets)
SELECT 
  COUNT(*) FILTER (WHERE COALESCE(monetary, 0) <= 100) AS under_100,
  COUNT(*) FILTER (WHERE monetary BETWEEN 100 AND 500) AS mid_range,
  COUNT(*) FILTER (WHERE monetary > 500) AS high_value,
  COUNT(*) AS total_users
FROM rfm_monetary;

-- Check how NTILE(5) over frequency distributes users
WITH freq_ranked AS (
    SELECT
        customer_unique_id,
        frequency,
        NTILE(5) OVER (ORDER BY frequency) AS f_score
    FROM rfm_frequency
)
SELECT 
    f_score,
    MIN(frequency) AS min_freq,
    MAX(frequency) AS max_freq,
    COUNT(*) AS user_count
FROM freq_ranked
GROUP BY f_score
ORDER BY f_score;

-- Recency distribution (3 quantiles)
SELECT 
  PERCENTILE_DISC(0.33) WITHIN GROUP (ORDER BY recency) AS r_33,
  PERCENTILE_DISC(0.67) WITHIN GROUP (ORDER BY recency) AS r_67
FROM rfm_recency;

-- Monetary distribution (5 quantiles)
SELECT 
  PERCENTILE_DISC(0.2) WITHIN GROUP (ORDER BY monetary) AS m_20,
  PERCENTILE_DISC(0.4) WITHIN GROUP (ORDER BY monetary) AS m_40,
  PERCENTILE_DISC(0.6) WITHIN GROUP (ORDER BY monetary) AS m_60,
  PERCENTILE_DISC(0.8) WITHIN GROUP (ORDER BY monetary) AS m_80
FROM rfm_monetary;
