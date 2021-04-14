#!/bin/bash -e
###############################################################
#
#
# from https://raspberrypi.stackexchange.com/questions/108592/use-systemd-networkd-for-general-networking/108593#108593
# undo the switch from debian to systemd networking
BACKUP_DIR=/var/systemd-nw-bak
if systemctl is-active --quiet systemd-networkd.service ; then
    apt-mark unhold ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog raspberrypi-net-mods openresolv
    apt install -y --download-only ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog raspberrypi-net-mods openresolv
    apt -y --autoremove purge libnss-resolve
    [ -d ${BACKUP_DIR}/dhcp ]    && mv ${BACKUP_DIR}/dhcp /etc/
    [ -d ${BACKUP_DIR}/network ] && mv ${BACKUP_DIR}/network /etc/
    [ -f ${BACKUP_DIR}/resolv.conf ] &&
	(
	    [ -f /etc/resolv.conf ] && rm /etc/resolv.conf
	    mv ${BACKUP_DIR}/resolv.conf /etc/resolv.conf
	)
    apt install -y ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog raspberrypi-net-mods openresolv
    systemctl disable wpa_supplicant@wlan0.service
    systemctl enable wpa_supplicant.service
    systemctl disable systemd-networkd.service systemd-resolved.service
fi
