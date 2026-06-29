CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_ml.arima_evaluate_store_dept` AS
SELECT
  *
FROM ML.ARIMA_EVALUATE(
  MODEL `sales-forecasting-dev-thiru.walmart_ml.model_sales_arima_plus_store_dept`
);
