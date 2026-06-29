from datetime import datetime

from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator


with DAG(
    dag_id="dag_00_sales_forecasting_master_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["master", "sales-forecasting"],
) as dag:

    run_raw_load = TriggerDagRunOperator(
        task_id="run_raw_load",
        trigger_dag_id="dag_01_load_raw_walmart_data",
        wait_for_completion=True,
        poke_interval=30,
        reset_dag_run=True,
    )

    run_staging = TriggerDagRunOperator(
        task_id="run_staging",
        trigger_dag_id="dag_02_create_staging_tables",
        wait_for_completion=True,
        poke_interval=30,
        reset_dag_run=True,
    )

    run_curated = TriggerDagRunOperator(
        task_id="run_curated",
        trigger_dag_id="dag_03_create_curated_tables",
        wait_for_completion=True,
        poke_interval=30,
        reset_dag_run=True,
    )

    run_features = TriggerDagRunOperator(
        task_id="run_features",
        trigger_dag_id="dag_04_create_feature_tables",
        wait_for_completion=True,
        poke_interval=30,
        reset_dag_run=True,
    )

    run_model_training = TriggerDagRunOperator(
        task_id="run_model_training",
        trigger_dag_id="dag_05_train_bqml_forecasting_model",
        wait_for_completion=True,
        poke_interval=60,
        reset_dag_run=True,
    )

    run_reporting = TriggerDagRunOperator(
        task_id="run_reporting",
        trigger_dag_id="dag_06_create_reporting_tables",
        wait_for_completion=True,
        poke_interval=30,
        reset_dag_run=True,
    )

    (
        run_raw_load
        >> run_staging
        >> run_curated
        >> run_features
        >> run_model_training
        >> run_reporting
    )
