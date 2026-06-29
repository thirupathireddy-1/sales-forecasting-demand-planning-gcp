# Sales Forecasting and Demand Planning System on GCP

## Project Overview

This project builds an end-to-end sales forecasting and demand planning system using Google Cloud Platform.

The system ingests Walmart weekly sales data, stores raw files in Google Cloud Storage, loads and transforms data in BigQuery, trains a BigQuery ML forecasting model, generates future demand forecasts, and exposes reporting tables for Looker Studio dashboards.

## Tech Stack

- Google Cloud Storage
- BigQuery
- BigQuery ML
- Apache Airflow on Compute Engine VM
- Looker Studio
- SQL
- Python/Airflow

## Dataset

Walmart Store Sales Forecasting dataset.

Files used:

- train.csv
- features.csv
- stores.csv

## Architecture

CSV files -> GCS -> BigQuery Raw -> BigQuery Staging -> BigQuery Curated -> Feature Tables -> BigQuery ML -> Reporting Tables -> Looker Studio

## Airflow DAGs

- dag_00_sales_forecasting_master_pipeline
- dag_01_load_raw_walmart_data
- dag_02_create_staging_tables
- dag_03_create_curated_tables
- dag_04_create_feature_tables
- dag_05_train_bqml_forecasting_model
- dag_06_create_reporting_tables

## BigQuery Datasets

- walmart_raw
- walmart_staging
- walmart_curated
- walmart_features
- walmart_ml
- walmart_reporting

## Model

The project uses BigQuery ML ARIMA_PLUS for store-department weekly sales forecasting.

Forecasting grain:

- store_id
- dept_id
- week_date

Forecast horizon:

- 12 weeks

## Dashboard

Looker Studio dashboard pages:

1. Executive Overview
2. Historical Sales Trends
3. Forecast Overview
4. Store Performance
5. Department Performance
6. Forecast Accuracy
7. Holiday and Markdown Impact

## Project Status

Completed until Phase 9:

- GCP setup
- Airflow setup
- Raw ingestion
- Staging transformations
- Curated tables
- Feature engineering
- BigQuery ML model training
- Reporting tables
- Looker Studio dashboard design
- Master Airflow DAG
Airflow Orchestration
The project uses Apache Airflow installed manually on a Compute Engine VM.
The master DAG runs all phase DAGs in sequence:
dag_01_load_raw_walmart_data
 -> dag_02_create_staging_tables
 -> dag_03_create_curated_tables
 -> dag_04_create_feature_tables
 -> dag_05_train_bqml_forecasting_model
 -> dag_06_create_reporting_tables
BigQuery Layering
Raw: source data loaded as-is
Staging: cleaned types, parsed dates, NA handling
Curated: business-ready fact and dimension tables
Features: lag, rolling, seasonality, promotion, economic features
ML: BigQuery ML models, evaluation, forecast outputs
Reporting: dashboard-ready tables
