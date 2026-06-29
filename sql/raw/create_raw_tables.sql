CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_raw.raw_sales` (
  Store INT64,
  Dept INT64,
  Date STRING,
  Weekly_Sales FLOAT64,
  IsHoliday BOOL
);

CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_raw.raw_features` (
  Store INT64,
  Date STRING,
  Temperature FLOAT64,
  Fuel_Price FLOAT64,
  MarkDown1 FLOAT64,
  MarkDown2 FLOAT64,
  MarkDown3 FLOAT64,
  MarkDown4 FLOAT64,
  MarkDown5 FLOAT64,
  CPI FLOAT64,
  Unemployment FLOAT64,
  IsHoliday BOOL
);

CREATE OR REPLACE TABLE `sales-forecasting-dev-thiru.walmart_raw.raw_stores` (
  Store INT64,
  Type STRING,
  Size INT64
);
