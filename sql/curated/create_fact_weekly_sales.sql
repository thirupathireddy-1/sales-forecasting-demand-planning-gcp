CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_curated.fact_weekly_sales`
PARTITION BY week_date
CLUSTER BY store_id, dept_id AS
SELECT
  s.store_id,
  s.dept_id,
  s.week_date,
  s.weekly_sales,
  s.is_holiday AS sales_is_holiday,

  ds.store_type,
  ds.store_size,
  ds.store_size_category,

  f.temperature,
  f.fuel_price,
  f.markdown_1,
  f.markdown_2,
  f.markdown_3,
  f.markdown_4,
  f.markdown_5,
  f.cpi,
  f.unemployment,
  f.is_holiday AS feature_is_holiday,

  COALESCE(f.markdown_1, 0)
    + COALESCE(f.markdown_2, 0)
    + COALESCE(f.markdown_3, 0)
    + COALESCE(f.markdown_4, 0)
    + COALESCE(f.markdown_5, 0) AS markdown_total,

  CURRENT_TIMESTAMP() AS curated_at
FROM `sales-forecasting-dev-thiru.walmart_staging.stg_sales` s
LEFT JOIN `sales-forecasting-dev-thiru.walmart_staging.stg_features` f
  ON s.store_id = f.store_id
 AND s.week_date = f.week_date
LEFT JOIN `sales-forecasting-dev-thiru.walmart_curated.dim_store` ds
  ON s.store_id = ds.store_id;
