CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_reporting.rpt_executive_summary` AS
WITH actuals AS (
  SELECT
    SUM(weekly_sales) AS total_historical_sales,
    COUNT(DISTINCT store_id) AS total_stores,
    COUNT(DISTINCT dept_id) AS total_departments,
    MIN(week_date) AS historical_start_date,
    MAX(week_date) AS historical_end_date
  FROM `sales-forecasting-dev-thiru.walmart_curated.fact_weekly_sales`
),

forecasts AS (
  SELECT
    SUM(forecast_weekly_sales) AS total_forecast_sales,
    MIN(week_date) AS forecast_start_date,
    MAX(week_date) AS forecast_end_date,
    COUNT(*) AS forecast_rows
  FROM `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_store_dept`
),

accuracy AS (
  SELECT
    AVG(mae) AS avg_mae,
    AVG(rmse) AS avg_rmse,
    AVG(mape) AS avg_mape
  FROM `sales-forecasting-dev-thiru.walmart_reporting.rpt_accuracy_by_store_dept`
)

SELECT
  a.total_historical_sales,
  a.total_stores,
  a.total_departments,
  a.historical_start_date,
  a.historical_end_date,

  f.total_forecast_sales,
  f.forecast_start_date,
  f.forecast_end_date,
  f.forecast_rows,

  ac.avg_mae,
  ac.avg_rmse,
  ac.avg_mape,

  CURRENT_TIMESTAMP() AS summary_created_at

FROM actuals a
CROSS JOIN forecasts f
CROSS JOIN accuracy ac;
