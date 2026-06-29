CREATE OR REPLACE MODEL `sales-forecasting-dev-thiru.walmart_ml.model_sales_arima_plus_smoke`
OPTIONS(
  MODEL_TYPE = 'ARIMA_PLUS',
  TIME_SERIES_TIMESTAMP_COL = 'week_date',
  TIME_SERIES_DATA_COL = 'weekly_sales',
  DATA_FREQUENCY = 'WEEKLY',
  HORIZON = 12,
  AUTO_ARIMA = TRUE,
  HOLIDAY_REGION = 'US'
) AS
SELECT
  week_date,
  weekly_sales
FROM `sales-forecasting-dev-thiru.walmart_features.forecasting_baseline_series`
WHERE store_id = 1
  AND dept_id = 1
ORDER BY week_date;
