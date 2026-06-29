CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_staging.stg_sales` AS
SELECT
  SAFE_CAST(Store AS INT64) AS store_id,
  SAFE_CAST(Dept AS INT64) AS dept_id,
  PARSE_DATE('%Y-%m-%d', Date) AS week_date,
  SAFE_CAST(Weekly_Sales AS FLOAT64) AS weekly_sales,
  SAFE_CAST(IsHoliday AS BOOL) AS is_holiday,
  CURRENT_TIMESTAMP() AS transformed_at
FROM `sales-forecasting-dev-thiru.walmart_raw.raw_sales`;
