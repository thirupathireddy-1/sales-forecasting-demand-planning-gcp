CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_staging.stg_stores` AS
SELECT
  SAFE_CAST(Store AS INT64) AS store_id,
  Type AS store_type,
  SAFE_CAST(Size AS INT64) AS store_size,
  CURRENT_TIMESTAMP() AS transformed_at
FROM `sales-forecasting-dev-thiru.walmart_raw.raw_stores`;
