CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_department`
PARTITION BY week_date
CLUSTER BY dept_id AS
SELECT
  dept_id,
  department_name,
  week_date,
  SUM(forecast_weekly_sales) AS forecast_weekly_sales,
  SUM(prediction_interval_lower_bound) AS forecast_lower_bound,
  SUM(prediction_interval_upper_bound) AS forecast_upper_bound,
  COUNT(DISTINCT store_id) AS store_count,
  MAX(forecast_generated_at) AS forecast_generated_at
FROM `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_store_dept`
GROUP BY dept_id, department_name, week_date;
