from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


PROJECT_DIR = "/home/thirupathireddypicharla/sales-forecasting-demand-planning"


with DAG(
    dag_id="dag_06_create_reporting_tables",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["walmart", "reporting"],
) as dag:

    create_forecast_by_store_dept = BashOperator(
        task_id="create_forecast_by_store_dept",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/reporting/create_rpt_forecast_by_store_dept.sql",
    )

    create_forecast_by_store = BashOperator(
        task_id="create_forecast_by_store",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/reporting/create_rpt_forecast_by_store.sql",
    )

    create_forecast_by_department = BashOperator(
        task_id="create_forecast_by_department",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/reporting/create_rpt_forecast_by_department.sql",
    )

    create_actual_sales_trends = BashOperator(
        task_id="create_actual_sales_trends",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/reporting/create_rpt_actual_sales_trends.sql",
    )

    create_forecast_vs_actual = BashOperator(
        task_id="create_forecast_vs_actual",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/reporting/create_rpt_forecast_vs_actual.sql",
    )

    create_accuracy_by_store_dept = BashOperator(
        task_id="create_accuracy_by_store_dept",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/reporting/create_rpt_accuracy_by_store_dept.sql",
    )

    create_executive_summary = BashOperator(
        task_id="create_executive_summary",
        bash_command=f"/snap/bin/bq query --use_legacy_sql=false < {PROJECT_DIR}/sql/reporting/create_rpt_executive_summary.sql",
    )

    create_forecast_by_store_dept >> [create_forecast_by_store, create_forecast_by_department]
    [create_forecast_by_store_dept, create_actual_sales_trends] >> create_forecast_vs_actual
    create_forecast_vs_actual >> create_accuracy_by_store_dept
    [create_forecast_by_store, create_forecast_by_department, create_accuracy_by_store_dept] >> create_executive_summary
