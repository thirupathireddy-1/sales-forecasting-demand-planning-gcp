CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_curated.dim_calendar` AS
SELECT
  week_date,
  EXTRACT(YEAR FROM week_date) AS year,
  EXTRACT(QUARTER FROM week_date) AS quarter,
  EXTRACT(MONTH FROM week_date) AS month,
  FORMAT_DATE('%B', week_date) AS month_name,
  EXTRACT(WEEK FROM week_date) AS week_of_year,
  EXTRACT(DAYOFWEEK FROM week_date) AS day_of_week,
  CASE
    WHEN EXTRACT(MONTH FROM week_date) IN (12, 1, 2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM week_date) IN (3, 4, 5) THEN 'Spring'
    WHEN EXTRACT(MONTH FROM week_date) IN (6, 7, 8) THEN 'Summer'
    ELSE 'Fall'
  END AS season,
  CURRENT_TIMESTAMP() AS curated_at
FROM (
  SELECT DISTINCT week_date
  FROM `sales-forecasting-dev-thiru.walmart_staging.stg_sales`
  WHERE week_date IS NOT NULL
);
