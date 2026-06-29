CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_ml.backtest_arima_plus_metrics` AS
WITH forecast AS (
  SELECT
    CAST(store_id AS INT64) AS store_id,
    CAST(dept_id AS INT64) AS dept_id,
    DATE(forecast_timestamp) AS week_date,
    forecast_value AS forecast_weekly_sales
  FROM ML.FORECAST(
    MODEL `sales-forecasting-dev-thiru.walmart_ml.model_arima_plus_backtest`,
    STRUCT(12 AS horizon, 0.80 AS confidence_level)
  )
),

actual AS (
  SELECT
    store_id,
    dept_id,
    week_date,
    weekly_sales AS actual_weekly_sales
  FROM `sales-forecasting-dev-thiru.walmart_features.forecasting_baseline_series`
),

comparison AS (
  SELECT
    f.store_id,
    f.dept_id,
    f.week_date,
    f.forecast_weekly_sales,
    a.actual_weekly_sales,
    f.forecast_weekly_sales - a.actual_weekly_sales AS error,
    ABS(f.forecast_weekly_sales - a.actual_weekly_sales) AS absolute_error,
    SAFE_DIVIDE(
      ABS(f.forecast_weekly_sales - a.actual_weekly_sales),
      NULLIF(ABS(a.actual_weekly_sales), 0)
    ) AS absolute_percentage_error
  FROM forecast f
  JOIN actual a
    ON f.store_id = a.store_id
   AND f.dept_id = a.dept_id
   AND f.week_date = a.week_date
)

SELECT
  COUNT(*) AS compared_rows,
  AVG(absolute_error) AS mae,
  SQRT(AVG(POW(error, 2))) AS rmse,
  AVG(absolute_percentage_error) AS mape,
  AVG(error) AS bias
FROM comparison;
