from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


PROJECT_DIR = "/home/thirupathireddypicharla/sales-forecasting-demand-planning"


with DAG(
    dag_id="dag_02_create_staging_tables",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["walmart", "staging"],
) as dag:

    create_stg_sales = BashOperator(
        task_id="create_stg_sales",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/staging/create_stg_sales.sql",
    )

    create_stg_features = BashOperator(
        task_id="create_stg_features",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/staging/create_stg_features.sql",
    )

    create_stg_stores = BashOperator(
        task_id="create_stg_stores",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/staging/create_stg_stores.sql",
    )

    [create_stg_sales, create_stg_features, create_stg_stores]
