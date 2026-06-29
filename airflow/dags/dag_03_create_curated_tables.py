from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


PROJECT_DIR = "/home/thirupathireddypicharla/sales-forecasting-demand-planning"


with DAG(
    dag_id="dag_03_create_curated_tables",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["walmart", "curated"],
) as dag:

    create_dim_store = BashOperator(
        task_id="create_dim_store",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/curated/create_dim_store.sql",
    )

    create_dim_department = BashOperator(
        task_id="create_dim_department",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/curated/create_dim_department.sql",
    )

    create_dim_calendar = BashOperator(
        task_id="create_dim_calendar",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/curated/create_dim_calendar.sql",
    )

    create_fact_weekly_sales = BashOperator(
        task_id="create_fact_weekly_sales",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/curated/create_fact_weekly_sales.sql",
    )

    [create_dim_store, create_dim_department, create_dim_calendar] >> create_fact_weekly_sales
