#! /bin/bash

########################################
# 1. 作業前　正常性確認
########################################


echo -e "$(date "+%Y-%m-%d %H:%M:%S") -> START SCRIPT\n"


########################################
##### RPM一覧を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> RPM一覧の取得を開始"
rpm -qa > ${RPM_TXT}
cat ${RPM_TXT} # ログからでも救出可能なように出力
echo -e "RPM一覧の取得を終了\n"
########################################


########################################
##### サービス一覧を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> サービス一覧の取得を開始"
systemctl list-units --type=service > ${SERVICES_TXT}
cat ${SERVICES_TXT}
echo -e "サービス一覧の取得を終了\n"
########################################


########################################
##### kernel情報を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> kernel情報の取得を開始"
uname -a > ${KERNEL_TXT}
cat ${KERNEL_TXT}
echo -e "kernel情報の取得を終了\n"
########################################


########################################
##### swap情報を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> swap情報の取得を開始"
free -h > ${SWAP_TXT}
cat ${SWAP_TXT}
echo -e "swap情報の取得を終了\n"
########################################


########################################
##### サービスが全てactiveなことを確認
echo "$(date "+%Y-%m-%d %H:%M:%S") -> サービスの死活情報の確認を開始"
# 各サービスのステータスを確認します。
# SERVICES="httpd named"のように空白区切りで定義される
for SERVICE in ${SERVICES}; do
  if systemctl is-active --quiet ${SERVICE}; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") -> ${SERVICE} は 稼働しています。"
  else
    echo "Error: ${SERVICE} は 稼働していません！"
    echo "$(date "+%Y-%m-%D" "%H:%M:%S") -> 正常性確認スクリプトは異常終了です。"
    exit 1
  fi
done
echo -e "サービスの死活情報の確認を終了\n"
########################################


echo "$(date "+%Y-%m-%d %H:%M:%S") -> 1.作業前確認スクリプトは正常に終了します。"