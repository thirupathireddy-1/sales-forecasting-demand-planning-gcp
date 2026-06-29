CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_ml.forecast_arima_plus_store_dept` AS
SELECT
  store_id,
  dept_id,
  forecast_timestamp AS week_date,
  forecast_value AS forecast_weekly_sales,
  prediction_interval_lower_bound,
  prediction_interval_upper_bound,
  CURRENT_TIMESTAMP() AS forecast_generated_at
FROM ML.FORECAST(
  MODEL `sales-forecasting-dev-thiru.walmart_ml.model_sales_arima_plus_store_dept`,
  STRUCT(12 AS horizon, 0.80 AS confidence_level)
);
