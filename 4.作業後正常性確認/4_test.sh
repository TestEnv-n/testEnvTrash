#! /bin/bash

########################################
# 1. 作業後　正常性確認
########################################


echo -e "$(date "+%Y-%m-%d %H:%M:%S") -> START SCRIPT\n"


########################################
##### reboot情報を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> reboot情報の取得を開始"
last --time-format iso reboot -3 > ${REBOOT_TXT}
cat ${REBOOT_TXT} # ログからでも救出可能なように出力
echo -e "reboot情報の取得を終了\n"
########################################


########################################
##### エラーメッセージの回収
echo "$(date "+%Y-%m-%d %H:%M:%S") -> エラーメッセージの回収を開始"

# boot.logを回収用に出力
echo "$(date "+%Y-%m-%d %H:%M:%S") -> boot.logの回収を開始"
sudo grep -ie warn -e err -e crit -e alert -e emerg -e panic /var/log/boot.log > ${BOOT_TXT}
cat ${BOOT_TXT}

# dmesgを回収用に出力
echo "$(date "+%Y-%m-%d %H:%M:%S") -> dmesgのログの回収を開始"
dmesg -T -l emerg,alert,crit,err,warn -x > ${DMESG_TXT}
cat ${DMESG_TXT}

# journalctlを回収用に出力
echo "$(date "+%Y-%m-%d %H:%M:%S") -> journalctlのログの回収を開始"
sudo journalctl /usr/lib/systemd/systemd -b -p warning > ${JOURNALCTL_TXT}
cat ${JOURNALCTL_TXT}

# sosreportを作成 --batchオプションで非対話式に出力
echo "$(date "+%Y-%m-%d %H:%M:%S") -> sosreportの作成を開始"
sudo sosreport --batch -q
ls -l /var/tmp | grep sosreport > ${SOSREPORT_TXT} # 確認観点は作成がされたか否か
cat ${SOSREPORT_TXT}
echo -e "エラーメッセージの回収を終了\n"
########################################


########################################
##### RPM一覧を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> RPM一覧の取得を開始"
rpm -qa > ${RPM_TXT}
cat ${RPM_TXT}
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
##### サービス一覧（設計書用）を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> RPM一覧の取得を開始"
systemctl list-unit-files -t service > ${SERVICES_DESIGN_TXT}
cat ${SERVICES_DESIGN_TXT}
echo -e "サービス一覧（設計書用）一覧の取得を終了\n"
########################################


########################################
##### kernel情報を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> kernel情報の取得を開始"
uname -a > ${KERNEL_TXT}
cat ${KERNEL_TXT}
echo -e "kernel情報の取得を終了\n"
########################################


########################################
##### 名前解決情報を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> 名前解決情報の取得を開始"
dig > ${DIG_TXT}
cat ${DIG_TXT}
echo -e "名前解決情報の取得を終了\n"
########################################


########################################
##### 時刻同期情報を取得
echo "$(date "+%Y-%m-%d %H:%M:%S") -> 時刻同期情報の取得を開始"
chronyc sources > ${CHRONYC_TXT}
cat ${CHRONYC_TXT}
echo -e "時刻同期情報の取得を終了\n"
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


echo "$(date "+%Y-%m-%D %H:%M:%S") -> 4.作業後正常性確認のスクリプトは正常に終了します。"