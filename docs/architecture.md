# Architecture

## End-to-End Flow

```text
Walmart CSV files
    |
    v
Google Cloud Storage
    |
    v
BigQuery Raw Dataset
    |
    v
BigQuery Staging Dataset
    |
    v
BigQuery Curated Dataset
    |
    v
Feature Engineering Tables
    |
    v
BigQuery ML ARIMA_PLUS Model
    |
    v
Forecast and Reporting Tables
    |
    v
Looker Studio Dashboard
