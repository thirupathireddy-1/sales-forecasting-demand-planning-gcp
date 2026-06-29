CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_features.store_dept_week_features`
PARTITION BY week_date
CLUSTER BY store_id, dept_id AS
WITH base AS (
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
    cpi,
    unemployment,

    COALESCE(markdown_1, 0) AS markdown_1,
    COALESCE(markdown_2, 0) AS markdown_2,
    COALESCE(markdown_3, 0) AS markdown_3,
    COALESCE(markdown_4, 0) AS markdown_4,
    COALESCE(markdown_5, 0) AS markdown_5,
    COALESCE(markdown_total, 0) AS markdown_total,

    EXTRACT(YEAR FROM week_date) AS year,
    EXTRACT(MONTH FROM week_date) AS month,
    EXTRACT(QUARTER FROM week_date) AS quarter,
    EXTRACT(WEEK FROM week_date) AS week_of_year,

    CASE
      WHEN EXTRACT(MONTH FROM week_date) IN (12, 1, 2) THEN 'Winter'
      WHEN EXTRACT(MONTH FROM week_date) IN (3, 4, 5) THEN 'Spring'
      WHEN EXTRACT(MONTH FROM week_date) IN (6, 7, 8) THEN 'Summer'
      ELSE 'Fall'
    END AS season,

    DATE_DIFF(
      week_date,
      MIN(week_date) OVER (),
      WEEK
    ) AS weeks_from_start

  FROM `sales-forecasting-dev-thiru.walmart_curated.fact_weekly_sales`
),

lagged AS (
  SELECT
    *,

    LAG(weekly_sales, 1) OVER w AS sales_lag_1,
    LAG(weekly_sales, 2) OVER w AS sales_lag_2,
    LAG(weekly_sales, 4) OVER w AS sales_lag_4,
    LAG(weekly_sales, 8) OVER w AS sales_lag_8,
    LAG(weekly_sales, 13) OVER w AS sales_lag_13,
    LAG(weekly_sales, 26) OVER w AS sales_lag_26,
    LAG(weekly_sales, 52) OVER w AS sales_lag_52,

    AVG(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING
    ) AS rolling_avg_4,

    AVG(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING
    ) AS rolling_avg_8,

    AVG(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN 13 PRECEDING AND 1 PRECEDING
    ) AS rolling_avg_13,

    STDDEV(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING
    ) AS rolling_std_4,

    STDDEV(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN 13 PRECEDING AND 1 PRECEDING
    ) AS rolling_std_13,

    MIN(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING
    ) AS rolling_min_4,

    MAX(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING
    ) AS rolling_max_4,

    AVG(weekly_sales) OVER (
      PARTITION BY store_id, dept_id
      ORDER BY week_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS store_dept_avg_sales_past,

    AVG(weekly_sales) OVER (
      PARTITION BY store_id
      ORDER BY week_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS store_avg_sales_past,

    AVG(weekly_sales) OVER (
      PARTITION BY dept_id
      ORDER BY week_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS dept_avg_sales_past,

    LAG(is_holiday, 1) OVER w AS previous_week_holiday,
    LEAD(is_holiday, 1) OVER w AS next_week_holiday

  FROM base
  WINDOW w AS (
    PARTITION BY store_id, dept_id
    ORDER BY week_date
  )
)

SELECT
  *,

  CASE WHEN markdown_total > 0 THEN TRUE ELSE FALSE END AS has_markdown,

  (
    CASE WHEN markdown_1 > 0 THEN 1 ELSE 0 END +
    CASE WHEN markdown_2 > 0 THEN 1 ELSE 0 END +
    CASE WHEN markdown_3 > 0 THEN 1 ELSE 0 END +
    CASE WHEN markdown_4 > 0 THEN 1 ELSE 0 END +
    CASE WHEN markdown_5 > 0 THEN 1 ELSE 0 END
  ) AS markdown_count,

  LOG(1 + markdown_total) AS log_markdown_total,

  weekly_sales - sales_lag_1 AS sales_change_1w,
  weekly_sales - sales_lag_4 AS sales_change_4w,

  SAFE_DIVIDE(weekly_sales - sales_lag_1, NULLIF(ABS(sales_lag_1), 0)) AS sales_pct_change_1w,
  SAFE_DIVIDE(weekly_sales - rolling_avg_4, NULLIF(ABS(rolling_avg_4), 0)) AS sales_vs_rolling_avg_4,

  rolling_avg_4 - rolling_avg_13 AS short_vs_medium_trend,

  CURRENT_TIMESTAMP() AS feature_created_at

FROM lagged;
