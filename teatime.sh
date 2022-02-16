#!/bin/sh
set -eu
finally() {
    # GCSのCSVを削除
    gsutil rm -rf gs://[your_gcs_backet]
    python3 /home/${dir}/notification.py "[info] バッチ終了"
}
trap finally EXIT

cd "$(dirname "$0")"

sudo timedatectl set-timezone Asia/Tokyo

dir='your_dir'
LAST_IMP=$(gsutil ls s3://[your_gcs_backet])

# BigQuerySQL実行&s3削除&s3エクスポート
echo Exporting for GCS
python3 /home/${dir}/main.py && gsutil rm $LAST_IMP && gsutil cp -r gs://[your_gcs_backet] s3://[your_gcs_backet] && python3 /home/${dir}/notification.py "[info] s3転送完了" 