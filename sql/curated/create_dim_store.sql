CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_curated.dim_store` AS
SELECT
  store_id,
  store_type,
  store_size,
  CASE
    WHEN store_size < 50000 THEN 'Small'
    WHEN store_size BETWEEN 50000 AND 150000 THEN 'Medium'
    ELSE 'Large'
  END AS store_size_category,
  CURRENT_TIMESTAMP() AS curated_at
FROM `sales-forecasting-dev-thiru.walmart_staging.stg_stores`;
