/*
===============================================================================
07 - User Product Preference Analysis
===============================================================================
Purpose:
    - Analyze product preferences for different customer segments
    - Identify which product categories are most frequently purchased by each RFM group
    - Support potential personalization, recommendation, or targeted marketing strategies

Tables Used:
    - olist_data
    - rfm_scored_labeled

SQL Functions Used:
    - COUNT(), ROUND(), SUM(... OVER ()), GROUP BY, JOIN

Output:
    - Product category rankings for each RFM segment (e.g., Champion, At Risk, etc.)
===============================================================================
*/

-- Distribution of customer labels
SELECT
    rfm_label,
    COUNT(*) AS count_of_label
FROM rfm_scored_labeled
GROUP BY rfm_label
ORDER BY count_of_label DESC;

-- Top 10 product categories for 'Champion' segment
SELECT
    o.product_category_name,
    o.product_category_name_english,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage,
    COUNT(*) AS purchase_count
FROM olist_data o
JOIN rfm_scored_labeled r
  ON o.customer_unique_id = r.customer_unique_id
WHERE r.rfm_label = 'Champion'
GROUP BY o.product_category_name, o.product_category_name_english
ORDER BY purchase_count DESC
LIMIT 10;

-- Top 10 product categories for 'Potential Loyalist' segment
SELECT
    o.product_category_name,
    o.product_category_name_english,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage,
    COUNT(*) AS purchase_count
FROM olist_data o
JOIN rfm_scored_labeled r
  ON o.customer_unique_id = r.customer_unique_id
WHERE r.rfm_label = 'Potential Loyalist'
GROUP BY o.product_category_name, o.product_category_name_english
ORDER BY purchase_count DESC
LIMIT 10;

-- Top 10 product categories for 'Loyal Customer' segment
SELECT
    o.product_category_name,
    o.product_category_name_english,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage,
    COUNT(*) AS purchase_count
FROM olist_data o
JOIN rfm_scored_labeled r
  ON o.customer_unique_id = r.customer_unique_id
WHERE r.rfm_label = 'Loyal Customer'
GROUP BY o.product_category_name, o.product_category_name_english
ORDER BY purchase_count DESC
LIMIT 10;

-- Most popular product category for 'At Risk' segment
SELECT
    o.product_category_name,
    o.product_category_name_english,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage,
    COUNT(*) AS purchase_count
FROM olist_data o
JOIN rfm_scored_labeled r
  ON o.customer_unique_id = r.customer_unique_id
WHERE r.rfm_label = 'At Risk'
GROUP BY o.product_category_name, o.product_category_name_english
ORDER BY purchase_count DESC
LIMIT 1;

-- Top 10 product categories for 'Recent Buyer' segment
SELECT
    o.product_category_name,
    o.product_category_name_english,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage,
    COUNT(*) AS purchase_count
FROM olist_data o
JOIN rfm_scored_labeled r
  ON o.customer_unique_id = r.customer_unique_id
WHERE r.rfm_label = 'Recent Buyer'
GROUP BY o.product_category_name, o.product_category_name_english
ORDER BY purchase_count DESC
LIMIT 10;

-- Top 10 product categories for 'Others' segment
SELECT
    o.product_category_name,
    o.product_category_name_english,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage,
    COUNT(*) AS purchase_count
FROM olist_data o
JOIN rfm_scored_labeled r
  ON o.customer_unique_id = r.customer_unique_id
WHERE r.rfm_label = 'Others'
GROUP BY o.product_category_name, o.product_category_name_english
ORDER BY purchase_count DESC
LIMIT 10;
