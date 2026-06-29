CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_reporting.rpt_actual_sales_trends`
PARTITION BY week_date
CLUSTER BY store_id, dept_id AS
SELECT
  store_id,
  dept_id,
  week_date,
  weekly_sales,
  sales_is_holiday AS is_holiday,
  store_type,
  store_size,
  store_size_category,
  temperature,
  fuel_price,
  markdown_total,
  cpi,
  unemployment,
  EXTRACT(YEAR FROM week_date) AS year,
  EXTRACT(MONTH FROM week_date) AS month,
  EXTRACT(QUARTER FROM week_date) AS quarter,
  EXTRACT(WEEK FROM week_date) AS week_of_year,
  CURRENT_TIMESTAMP() AS reporting_created_at
FROM `sales-forecasting-dev-thiru.walmart_curated.fact_weekly_sales`;
