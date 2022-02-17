from google.cloud import bigquery
from notification import slack_post
import os
import datetime
import sys

def query_ga():
  dir = sys.argv[1]
  project = 'your_gcp_projectid'

  # auth
  credentials_json = f'{dir}/client_credentials.json'
  os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credentials_json
  client = bigquery.Client(project=project)
  now = datetime.datetime.now()

  slack_post(f"[info] エクスポート開始")
  
  try:
    # SQL
    query = f"""
    EXPORT DATA OPTIONS(
      uri='gs://[your_gcs_backet]/{now.strftime("%Y-%m-%d-%H:%M")}-*.csv',
      format='CSV',
      overwrite=true,
      header=false,
      field_delimiter=','
    ) AS
    SELECT * FROM `[your_table_id]` limit 30;
    """
    results = client.query(query).result()
    print(results)
    slack_post("[info] BigQuery->GCSエクスポート完了")
    exit(0)
  except Exception as ex:
    print(ex)
    exit(1)
if __name__ == '__main__':
  query_ga()