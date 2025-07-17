# Olist RFM Customer Segmentation

This project performs customer segmentation on the Olist e-commerce dataset using SQL and the RFM (Recency, Frequency, Monetary) framework. The analysis is conducted entirely in PostgreSQL, with Python used for data ingestion and preprocessing.

The data used in this project comes from the **silver layer** of my [Olist Data Engineering Pipeline](https://github.com/Beatrice-127/my-projects/tree/main/ecommerce_data_engineering), where I built an end-to-end ETL process using Azure and transformed raw data into analysis-ready tables.

## Dataset

This project uses the [Olist Brazilian E-commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), published on Kaggle by Olist, a real Brazilian e-commerce platform.

The dataset contains nearly **100,000 orders**, with detailed information across **37 columns**, including:

- Order lifecycle: purchase time, delivery time, and order status
- Customer identifiers (anonymized)
- Product category and seller information
- Payment amounts and freight costs

The data spans from **September 2016 to October 2018**, covering the full customer journey from purchase to delivery.


## Objectives

- Clean and prepare customer and order data from Olist
- Create time-based and value-based views to support user-level aggregation
- Build custom RFM scoring and user labeling logic based on data distribution
- Identify product preferences across user segments
- Produce metrics such as DAU, MAU, GMV, and ARPU

