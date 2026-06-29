## Start VM

```bash
gcloud compute instances start airflow-vm --zone=us-central1-a

## SSH Into VM
gcloud compute ssh airflow-vm --zone=us-central1-a

## Start Airflow

cd ~/sales-forecasting-demand-planning
source .venv/bin/activate
export AIRFLOW_HOME=~/airflow
airflow standalone

## Open Airflow UI
Run Full Pipeline
Trigger:
dag_00_sales_forecasting_master_pipeline

#3 Validate Final Tables
bq query --use_legacy_sql=false "
SELECT 'raw_sales' AS table_name, COUNT(*) AS row_count
FROM \`sales-forecasting-dev-thiru.walmart_raw.raw_sales\`
UNION ALL
SELECT 'stg_sales', COUNT(*)
FROM \`sales-forecasting-dev-thiru.walmart_staging.stg_sales\`
UNION ALL
SELECT 'fact_weekly_sales', COUNT(*)
FROM \`sales-forecasting-dev-thiru.walmart_curated.fact_weekly_sales\`
UNION ALL
SELECT 'training_features', COUNT(*)
FROM \`sales-forecasting-dev-thiru.walmart_features.training_features\`
UNION ALL
SELECT 'forecast_rows', COUNT(*)
FROM \`sales-forecasting-dev-thiru.walmart_ml.forecast_arima_plus_store_dept\`
UNION ALL
SELECT 'reporting_rows', COUNT(*)
FROM \`sales-forecasting-dev-thiru.walmart_reporting.rpt_forecast_by_store_dept\`;
"

## Stop VM To Save Cost
gcloud compute instances stop airflow-vm --zone=us-central1-a
