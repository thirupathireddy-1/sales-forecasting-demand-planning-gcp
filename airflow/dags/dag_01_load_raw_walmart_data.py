from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


with DAG(
    dag_id="dag_01_load_raw_walmart_data",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["walmart", "raw-load"],
) as dag:

    load_raw_sales = BashOperator(
        task_id="load_raw_sales",
        bash_command="""
        /snap/bin/bq load \
          --source_format=CSV \
          --skip_leading_rows=1 \
          --replace \
          sales-forecasting-dev-thiru:walmart_raw.raw_sales \
          gs://sales-forecasting-dev-raw/landing/walmart/train/train.csv \
          Store:INTEGER,Dept:INTEGER,Date:STRING,Weekly_Sales:FLOAT,IsHoliday:BOOLEAN
        """,
    )

    load_raw_features = BashOperator(
        task_id="load_raw_features",
        bash_command="""
        /snap/bin/bq load \
          --source_format=CSV \
          --skip_leading_rows=1 \
          --replace \
          --allow_quoted_newlines \
          sales-forecasting-dev-thiru:walmart_raw.raw_features \
          gs://sales-forecasting-dev-raw/landing/walmart/features/features.csv \
          Store:STRING,Date:STRING,Temperature:STRING,Fuel_Price:STRING,MarkDown1:STRING,MarkDown2:STRING,MarkDown3:STRING,MarkDown4:STRING,MarkDown5:STRING,CPI:STRING,Unemployment:STRING,IsHoliday:STRING
        """,
    )

    load_raw_stores = BashOperator(
        task_id="load_raw_stores",
        bash_command="""
        /snap/bin/bq load \
          --source_format=CSV \
          --skip_leading_rows=1 \
          --replace \
          sales-forecasting-dev-thiru:walmart_raw.raw_stores \
          gs://sales-forecasting-dev-raw/landing/walmart/stores/stores.csv \
          Store:INTEGER,Type:STRING,Size:INTEGER
        """,
    )

    [load_raw_sales, load_raw_features, load_raw_stores]
