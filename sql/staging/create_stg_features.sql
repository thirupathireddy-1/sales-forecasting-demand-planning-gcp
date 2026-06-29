CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_staging.stg_features` AS
SELECT
  SAFE_CAST(Store AS INT64) AS store_id,
  PARSE_DATE('%Y-%m-%d', Date) AS week_date,

  SAFE_CAST(NULLIF(Temperature, 'NA') AS FLOAT64) AS temperature,
  SAFE_CAST(NULLIF(Fuel_Price, 'NA') AS FLOAT64) AS fuel_price,

  SAFE_CAST(NULLIF(MarkDown1, 'NA') AS FLOAT64) AS markdown_1,
  SAFE_CAST(NULLIF(MarkDown2, 'NA') AS FLOAT64) AS markdown_2,
  SAFE_CAST(NULLIF(MarkDown3, 'NA') AS FLOAT64) AS markdown_3,
  SAFE_CAST(NULLIF(MarkDown4, 'NA') AS FLOAT64) AS markdown_4,
  SAFE_CAST(NULLIF(MarkDown5, 'NA') AS FLOAT64) AS markdown_5,

  SAFE_CAST(NULLIF(CPI, 'NA') AS FLOAT64) AS cpi,
  SAFE_CAST(NULLIF(Unemployment, 'NA') AS FLOAT64) AS unemployment,
  SAFE_CAST(IsHoliday AS BOOL) AS is_holiday,

  CURRENT_TIMESTAMP() AS transformed_at
FROM `sales-forecasting-dev-thiru.walmart_raw.raw_features`;
