CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_store_dept`
PARTITION BY week_date
CLUSTER BY store_id, dept_id AS
WITH forecast_base AS (
  SELECT
    CAST(store_id AS INT64) AS store_id,
    CAST(dept_id AS INT64) AS dept_id,
    DATE(week_date) AS week_date,
    forecast_weekly_sales,
    prediction_interval_lower_bound,
    prediction_interval_upper_bound,
    forecast_generated_at
  FROM `sales-forecasting-dev-thiru.walmart_ml.forecast_arima_plus_store_dept`
)
SELECT
  f.store_id,
  f.dept_id,
  f.week_date,
  f.forecast_weekly_sales,
  f.prediction_interval_lower_bound,
  f.prediction_interval_upper_bound,
  ds.store_type,
  ds.store_size,
  ds.store_size_category,
  dd.department_name,
  dc.year,
  dc.quarter,
  dc.month,
  dc.month_name,
  dc.week_of_year,
  dc.season,
  f.forecast_generated_at
FROM forecast_base f
LEFT JOIN `sales-forecasting-dev-thiru.walmart_curated.dim_store` ds
  ON f.store_id = ds.store_id
LEFT JOIN `sales-forecasting-dev-thiru.walmart_curated.dim_department` dd
  ON f.dept_id = dd.dept_id
LEFT JOIN `sales-forecasting-dev-thiru.walmart_curated.dim_calendar` dc
  ON f.week_date = dc.week_date;
