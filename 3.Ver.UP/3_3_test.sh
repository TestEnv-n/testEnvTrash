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
##### Kernel & redhat-release のアップデート
DNF=/etc/dnf/dnf.conf
sed -i "/^exclude=/d" ${DNF}
echo ${EXCLUDE_1} >> ${DNF}
cat ${DNF}

echo "$(date "+%Y-%m-%D %H:%M:%S") -> Kernel Ver.UP を開始します。"
yum install ${KERNEL_VER} -y
INSTALLED_KERNEL=$(uname -r)
if [[ "${INSTALLED_KERNEL}" != *"${KERNEL_VER}"* ]]; then
    echo "Error: インストールされたKernelバージョンが想定と異なります。"
    echo "Ver.UPスクリプトは異常終了です。"
    exit 1
fi

echo "$(date "+%Y-%m-%D %H:%M:%S") -> redhat-release Ver.UP を開始します。"
yum install ${RH_RELEASE} -y
INSTALLED_RH_RELEASE=$(rpm -q --qf "%{VERSION}" redhat-release)
if [[ "${INSTALLED_RH_RELEASE}" != *"${RH_RELEASE_VER}"* ]]; then
    echo "Error: インストールされたredhat-releaseのバージョンが想定と異なります。"
    echo "Ver.UPスクリプトは異常終了です。"
    exit 1
fi

sed -i "/^exclude=/d" ${DNF}
echo "${EXCLUDE_2}" >> ${DNF}
cat ${DNF}
########################################


########################################
##### セキュリティパッチの適用
echo "$(date "+%Y-%m-%D %H:%M:%S") -> セキュリティパッチの適用 を開始します。"
yum update --security -y
########################################

echo "$(date "+%Y-%m-%D %H:%M:%S") -> 3.Ver.UPスクリプトは正常に終了します。"