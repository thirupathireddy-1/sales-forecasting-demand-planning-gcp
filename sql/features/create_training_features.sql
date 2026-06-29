CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_features.training_features`
PARTITION BY week_date
CLUSTER BY store_id, dept_id AS
SELECT
  store_id,
  dept_id,
  week_date,

  weekly_sales AS target_weekly_sales,

  is_holiday,
  previous_week_holiday,
  next_week_holiday,

  store_type,
  store_size,
  store_size_category,

  temperature,
  fuel_price,
  cpi,
  unemployment,

  markdown_1,
  markdown_2,
  markdown_3,
  markdown_4,
  markdown_5,
  markdown_total,
  has_markdown,
  markdown_count,
  log_markdown_total,

  year,
  month,
  quarter,
  week_of_year,
  season,
  weeks_from_start,

  sales_lag_1,
  sales_lag_2,
  sales_lag_4,
  sales_lag_8,
  sales_lag_13,
  sales_lag_26,
  sales_lag_52,

  rolling_avg_4,
  rolling_avg_8,
  rolling_avg_13,
  rolling_std_4,
  rolling_std_13,
  rolling_min_4,
  rolling_max_4,

  store_dept_avg_sales_past,
  store_avg_sales_past,
  dept_avg_sales_past,

  CASE
    WHEN week_date < DATE '2012-07-01' THEN 'TRAIN'
    WHEN week_date < DATE '2012-09-01' THEN 'VALIDATION'
    ELSE 'TEST'
  END AS data_split,

  CURRENT_TIMESTAMP() AS training_feature_created_at

FROM `sales-forecasting-dev-thiru.walmart_features.store_dept_week_features`
WHERE sales_lag_52 IS NOT NULL
  AND rolling_avg_13 IS NOT NULL
  AND store_dept_avg_sales_past IS NOT NULL;
