from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


PROJECT_DIR = "/home/thirupathireddypicharla/sales-forecasting-demand-planning"


with DAG(
    dag_id="dag_04_create_feature_tables",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["walmart", "features"],
) as dag:

    create_store_dept_week_features = BashOperator(
        task_id="create_store_dept_week_features",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/features/create_store_dept_week_features.sql",
    )

    create_training_features = BashOperator(
        task_id="create_training_features",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/features/create_training_features.sql",
    )

    create_forecasting_baseline_series = BashOperator(
        task_id="create_forecasting_baseline_series",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/features/create_forecasting_baseline_series.sql",
    )

    create_store_dept_week_features >> [create_training_features, create_forecasting_baseline_series]
