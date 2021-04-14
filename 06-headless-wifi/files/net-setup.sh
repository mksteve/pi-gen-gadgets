#!/bin/bash
/opt/wifi-network/store-names.py "$1" "$2"
tfile=$(mktemp)
/opt/wifi-network/build-wpa-file.py /var/web-networks/nets.db > $tfile
cat /etc/wpa_supplicant/wpa_supplicant-wlan0.conf.base $tfile > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
#rm $tfile
systemctl daemon-reload
systemctl stop wpa_supplicant@wlan0.service
systemctl start wpa_supplicant@wlan0.service
