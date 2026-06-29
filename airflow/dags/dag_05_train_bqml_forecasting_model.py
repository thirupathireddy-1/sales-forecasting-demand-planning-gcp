from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


PROJECT_DIR = "/home/thirupathireddypicharla/sales-forecasting-demand-planning"


with DAG(
    dag_id="dag_05_train_bqml_forecasting_model",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["walmart", "bqml", "forecasting"],
) as dag:

    train_arima_plus_store_dept = BashOperator(
        task_id="train_arima_plus_store_dept",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/ml/create_model_arima_plus_store_dept.sql",
    )

    evaluate_arima_plus_store_dept = BashOperator(
        task_id="evaluate_arima_plus_store_dept",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/ml/evaluate_model_arima_plus_store_dept.sql",
    )

    forecast_arima_plus_store_dept = BashOperator(
        task_id="forecast_arima_plus_store_dept",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/ml/forecast_model_arima_plus_store_dept.sql",
    )

    register_model = BashOperator(
        task_id="register_model",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/ml/create_model_registry_entry.sql",
    )

    train_arima_plus_store_dept >> evaluate_arima_plus_store_dept >> forecast_arima_plus_store_dept >> register_model
