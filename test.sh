#! /bin/bash

echo "START SCRIPT"

echo "Writing ${RPM_TXT}."
rpm -qa > ${RPM_TXT}
cat ${RPM_TXT}

echo "Confirm Service Status."
# 各サービスのステータスを確認します
for SERVICE in $SERVICES; do
  if systemctl is-active --quiet $SERVICE; then
    echo "$SERVICE is running."
  else
    echo "Error: $SERVICE is not running."
    exit 1
  fi
done

echo "All services are running."