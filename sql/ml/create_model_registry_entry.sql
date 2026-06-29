CREATE TABLE IF NOT EXISTS `sales-forecasting-dev-thiru.walmart_ml.model_registry` (
  model_name STRING,
  model_type STRING,
  model_grain STRING,
  forecast_horizon INT64,
  trained_at TIMESTAMP,
  training_table STRING,
  evaluation_table STRING,
  forecast_table STRING,
  is_champion BOOL,
  notes STRING
);

INSERT INTO `sales-forecasting-dev-thiru.walmart_ml.model_registry`
VALUES (
  'model_sales_arima_plus_store_dept',
  'ARIMA_PLUS',
  'store_id + dept_id + week_date',
  12,
  CURRENT_TIMESTAMP(),
  'walmart_features.forecasting_baseline_series',
  'walmart_ml.eval_arima_plus_store_dept',
  'walmart_ml.forecast_arima_plus_store_dept',
  TRUE,
  'First full store-department ARIMA_PLUS baseline model'
);
