CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_features.forecasting_baseline_series`
PARTITION BY week_date
CLUSTER BY store_id, dept_id AS
SELECT
  store_id,
  dept_id,
  week_date,
  weekly_sales
FROM `sales-forecasting-dev-thiru.walmart_curated.fact_weekly_sales`
WHERE weekly_sales IS NOT NULL
  AND week_date IS NOT NULL;
