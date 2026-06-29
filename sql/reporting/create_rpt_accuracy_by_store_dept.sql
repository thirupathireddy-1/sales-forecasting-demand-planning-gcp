CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_reporting.rpt_accuracy_by_store_dept` AS
SELECT
  store_id,
  dept_id,
  COUNT(*) AS compared_weeks,
  AVG(absolute_error) AS mae,
  SQRT(AVG(POW(forecast_error, 2))) AS rmse,
  AVG(absolute_percentage_error) AS mape,
  AVG(forecast_error) AS bias,
  CURRENT_TIMESTAMP() AS reporting_created_at
FROM `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_vs_actual`
WHERE comparison_status = 'ACTUAL_AVAILABLE'
GROUP BY store_id, dept_id;
