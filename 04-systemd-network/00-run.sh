#!/bin/bash -e
install -m 755 -d "${ROOTFS_DIR}/opt/network-switch"
install -m 744 files/enable-systemd.sh "${ROOTFS_DIR}/opt/network-switch/"
install -m 744 files/enable-debian.sh "${ROOTFS_DIR}/opt/network-switch/"
echo ${WPA_COUNTRY} > "${ROOTFS_DIR}/etc/wifi-country"
on_chroot <<EOF
/opt/network-switch/enable-systemd.sh --force
EOF
