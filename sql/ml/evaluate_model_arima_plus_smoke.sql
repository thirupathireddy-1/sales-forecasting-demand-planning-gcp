CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_ml.eval_arima_plus_smoke` AS
SELECT
  *
FROM ML.EVALUATE(
  MODEL `sales-forecasting-dev-thiru.walmart_ml.model_sales_arima_plus_smoke`
);
