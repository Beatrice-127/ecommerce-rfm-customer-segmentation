# Olist RFM Customer Segmentation

This project performs customer segmentation on the Olist e-commerce dataset using SQL and the RFM (Recency, Frequency, Monetary) framework. The analysis is conducted entirely in PostgreSQL, with Python used for data ingestion and preprocessing.

This project uses data from the **silver layer** of my project [Olist Data Engineering Pipeline](https://github.com/Beatrice-127/my-projects/tree/main/ecommerce_data_engineering), where I built an end-to-end ETL process using Azure and transformed raw data into analysis-ready tables.

## Objectives

- Clean and prepare customer and order data from Olist
- Create time-based and value-based views to support user-level aggregation
- Build custom RFM scoring and user labeling logic based on data distribution
- Identify product preferences across user segments
- Produce metrics such as DAU, MAU, GMV, and ARPU

