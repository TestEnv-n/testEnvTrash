#! /bin/bash

########################################
# 3. Ver.UP 作業
########################################

echo "$(date "+%Y-%m-%D %H:%M:%S") -> START SCRIPT !"

########################################
##### サービスが正常稼働していればサービス停止
echo "サービス停止処理 を開始します。"
# SERVICES="httpd named"のように空白区切りで定義される
for SERVICE in ${SERVICES}; do
    if systemctl is-active --quiet ${SERVICE}; then
    echo "${SERVICE} は稼働しています。"
    echo "$(date "+%Y-%m-%D %H:%M:%S") -> ${SERVICE} を停止します。"
    systemctl stop ${SERVICE}
        if systemctl is-active --quiet ${SERVICE}; then
            echo "Error: ${SERVICE} は停止していません。"
            echo "Ver.UPスクリプトは異常終了です。"
            exit 1
        else
            echo "${SERVICE} は停止しました。"
            echo "処理を継続します。"
        fi
    else
        echo "Error: ${SERVICE} は稼働していません！"
        echo "Ver.UPスクリプトは異常終了です。"
        exit 1
    fi
done
echo "$(date "+%Y-%m-%D %H:%M:%S") -> サービス停止処理 を正常に完了しました。"
########################################


########################################
##### Kernel & redhat-release のアップデート 無
########################################


########################################
##### セキュリティパッチの適用
echo "$(date "+%Y-%m-%D %H:%M:%S") -> セキュリティパッチの適用 を開始"
yum update --security -y
########################################

echo "$(date "+%Y-%m-%D %H:%M:%S") -> 3.Ver.UPスクリプトは正常に終了します。"