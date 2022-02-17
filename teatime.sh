#!/bin/sh
set -eu
finally() {
    # GCSのCSVを削除
    gsutil rm -rf gs://[your_gcs_backet]
    python3 ${dir}/notification.py "[info] バッチ終了"
}
trap finally EXIT

dir=$(cd $(dirname $0);pwd) 

sudo timedatectl set-timezone Asia/Tokyo

LAST_IMP=$(gsutil ls s3://[your_gcs_backet])

# BigQuerySQL実行&s3削除&s3エクスポート
echo Exporting for GCS
python3 ${dir}/main.py dir && gsutil rm $LAST_IMP && gsutil cp -r gs://[your_gcs_backet] s3://[your_gcs_backet] && python3 ${dir}/notification.py "[info] s3転送完了" 