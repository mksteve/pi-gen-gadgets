#!/bin/bash -e
install -m 755 -d "${ROOTFS_DIR}/var/web-networks"
install -m 644 files/index.html "${ROOTFS_DIR}/var/www/html/index.html"
install -m 644 files/new-wifi.php "${ROOTFS_DIR}/var/www/html/new-wifi.php"
install -m 755 files/net-setup.sh "${ROOTFS_DIR}/usr/local/bin/net-setup.sh"
install -m 755 -d "${ROOTFS_DIR}/opt/wifi-network/"
install -m 744 files/build-wpa-file.py "${ROOTFS_DIR}/opt/wifi-network/build-wpa-file.py"
install -m 744 files/store-names.py "${ROOTFS_DIR}/opt/wifi-network/store-names.py"
install -m 440 files/www-sudo "${ROOTFS_DIR}/etc/sudoers.d/www-sudo"
cp "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf" "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf.base"

on_chroot <<EOF
sqlite3 "/var/web-networks/nets.db" "CREATE TABLE networks ( network TEXT PRIMARY KEY ON CONFLICT REPLACE, password TEXT );"
systemctl disable hostapd.service
EOF


