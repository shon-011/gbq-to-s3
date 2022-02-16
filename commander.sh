#!/bin/sh
set -eu
cd "$(dirname "$0")"

dir=[yourdir]

# 20分間監視
TIMEOUT=1200
count=0
while [ $count -le $TIMEOUT ]; do
  ps=`ps aux | grep teatime.sh | grep -v grep | wc -l`
  if [ $ps -eq 0 ]; then # 対象プロセスが存在しない場合
    ./teatime.sh
    exit 0
  fi
  python3 /home/${dir}/notification.py "<!channel> [warning] teatimeプロセスが実行中です。突き抜けが発生"
  sleep 5m
  count=`expr $count + 15`
  echo $count
done
echo "TIMEOUT exit 1"
exit 1