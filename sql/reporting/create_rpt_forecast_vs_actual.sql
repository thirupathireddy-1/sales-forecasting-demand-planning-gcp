CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_vs_actual`
PARTITION BY week_date
CLUSTER BY store_id, dept_id AS
SELECT
  f.store_id,
  f.dept_id,
  f.week_date,
  f.forecast_weekly_sales,
  a.weekly_sales AS actual_weekly_sales,
  f.prediction_interval_lower_bound,
  f.prediction_interval_upper_bound,

  CASE
    WHEN a.weekly_sales IS NULL THEN NULL
    ELSE f.forecast_weekly_sales - a.weekly_sales
  END AS forecast_error,

  CASE
    WHEN a.weekly_sales IS NULL THEN NULL
    ELSE ABS(f.forecast_weekly_sales - a.weekly_sales)
  END AS absolute_error,

  CASE
    WHEN a.weekly_sales IS NULL OR a.weekly_sales = 0 THEN NULL
    ELSE SAFE_DIVIDE(ABS(f.forecast_weekly_sales - a.weekly_sales), ABS(a.weekly_sales))
  END AS absolute_percentage_error,

  CASE
    WHEN a.weekly_sales IS NULL THEN 'FUTURE_NO_ACTUAL'
    ELSE 'ACTUAL_AVAILABLE'
  END AS comparison_status,

  f.forecast_generated_at,
  CURRENT_TIMESTAMP() AS reporting_created_at

FROM `sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_store_dept` f
LEFT JOIN `sales-forecasting-dev-thiru.walmart_curated.fact_weekly_sales` a
  ON f.store_id = a.store_id
 AND f.dept_id = a.dept_id
 AND f.week_date = a.week_date;
