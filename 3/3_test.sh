#! /bin/bash

########################################
# 1. 作業前　正常性確認
########################################


echo "START SCRIPT"


########################################
##### RPM一覧を取得
echo "記入：${RPM_TXT}."
rpm -qa > ${RPM_TXT}
echo "完了：${RPM_TXT}."
# 頭と最後のRPMが出力ファイルと一致していることを確認する作業
echo "出力：${RPM_TXT}."
cat ${RPM_TXT}
########################################


########################################
##### サービス一覧を取得
echo "記入：${SERVICES_TXT}."
systemctl list-units --type=service > ${SERVICES_TXT}
echo "完了：${SERVICES_TXT}."
# 頭と最後のRPMが出力ファイルと一致していることを確認する作業
echo "出力：${SERVICES_TXT}."
cat ${SERVICES_TXT}
########################################


########################################
##### kernel情報を取得
echo "記入：${KERNEL_TXT}."
uname -a > ${KERNEL_TXT}
echo "完了：${KERNEL_TXT}."
# 頭と最後のRPMが出力ファイルと一致していることを確認する作業
echo "出力：${KERNEL_TXT}."
cat ${KERNEL_TXT}
########################################


########################################
##### swap情報を取得
echo "記入：${SWAP_TXT}."
free -h > ${SWAP_TXT}
echo "完了：${SWAP_TXT}."
# 頭と最後のRPMが出力ファイルと一致していることを確認する作業
echo "出力：${SWAP_TXT}."
cat ${SWAP_TXT}
########################################


########################################
##### サービスが全てactiveなことを確認
echo "Confirm Service Status."
# 各サービスのステータスを確認します。
# SERVICES="httpd named"のように空白区切りで定義される
for SERVICE in ${SERVICES}; do
  if systemctl is-active --quiet ${SERVICE}; then
    echo "${SERVICE} は 稼働しています。"
  else
    echo "Error: ${SERVICE} は 稼働していません！"
    echo "正常性確認スクリプトは異常終了です。"
    exit 1
  fi
done
########################################


echo "正常性確認スクリプトは正常に終了します。"