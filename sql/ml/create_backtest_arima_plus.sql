CREATE OR REPLACE MODEL `sales-forecasting-dev-thiru.walmart_ml.model_arima_plus_backtest`
OPTIONS(
  MODEL_TYPE = 'ARIMA_PLUS',
  TIME_SERIES_TIMESTAMP_COL = 'week_date',
  TIME_SERIES_DATA_COL = 'weekly_sales',
  TIME_SERIES_ID_COL = ['store_id', 'dept_id'],
  DATA_FREQUENCY = 'WEEKLY',
  HORIZON = 12,
  AUTO_ARIMA = TRUE,
  HOLIDAY_REGION = 'US'
) AS
SELECT
  CAST(store_id AS STRING) AS store_id,
  CAST(dept_id AS STRING) AS dept_id,
  week_date,
  weekly_sales
FROM `sales-forecasting-dev-thiru.walmart_features.forecasting_baseline_series`
WHERE week_date <= DATE_SUB(
  (SELECT MAX(week_date) FROM `sales-forecasting-dev-thiru.walmart_features.forecasting_baseline_series`),
  INTERVAL 12 WEEK
);
