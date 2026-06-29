CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_store`
PARTITION BY week_date
CLUSTER BY store_id AS
SELECT
  store_id,
  week_date,
  ANY_VALUE(store_type) AS store_type,
  ANY_VALUE(store_size) AS store_size,
  ANY_VALUE(store_size_category) AS store_size_category,
  SUM(forecast_weekly_sales) AS forecast_weekly_sales,
  SUM(prediction_interval_lower_bound) AS forecast_lower_bound,
  SUM(prediction_interval_upper_bound) AS forecast_upper_bound,
  COUNT(DISTINCT dept_id) AS department_count,
  MAX(forecast_generated_at) AS forecast_generated_at
FROM `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_store_dept`
GROUP BY store_id, week_date;
