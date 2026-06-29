CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_curated.dim_department` AS
SELECT
  dept_id,
  CONCAT('Department ', CAST(dept_id AS STRING)) AS department_name,
  CURRENT_TIMESTAMP() AS curated_at
FROM (
  SELECT DISTINCT dept_id
  FROM `sales-forecasting-dev-thiru.walmart_staging.stg_sales`
)
WHERE dept_id IS NOT NULL;
