#!/bin/bash -e

install -m 755 -d "${ROOTFS_DIR}/etc/systemd/system/wpa_supplicant@wlan0.service.d"
install -m 644 files/override.conf "${ROOTFS_DIR}/etc/systemd/system/wpa_supplicant@wlan0.service.d"
cat > ${ROOTFS_DIR}/etc/hostapd/hostapd.conf <<EOF
country_code=_WPA_COUNTRY_
ssid=_HOTSPOT_SSID_
logger_syslog=1
hw_mode=g
channel=_HOTSPOT_CHANNEL_
macaddr_acl=0
auth_algs=1
#ignore_broadcast_ssid=1
wpa=2
wpa_passphrase=_HOTSPOT_PASSWORD_
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

sed -i "s/_WPA_COUNTRY_/${WPA_COUNTRY}/g"   "${ROOTFS_DIR}/etc/hostapd/hostapd.conf"
sed -i "s/_HOTSPOT_SSID_/${HOTSPOT_SSID}/g" "${ROOTFS_DIR}/etc/hostapd/hostapd.conf"
sed -i "s/_HOTSPOT_CHANNEL_/${HOTSPOT_CHANNEL}/g" "${ROOTFS_DIR}/etc/hostapd/hostapd.conf"
sed -i "s/_HOTSPOT_PASSWORD_/${HOTSPOT_PASSWORD}/g" "${ROOTFS_DIR}/etc/hostapd/hostapd.conf"

cat > ${ROOTFS_DIR}/etc/systemd/system/accesspoint@.service <<EOF
[Unit]
Description=accesspoint with hostapd (interface-specific version)
Wants=wpa_supplicant@%i.service

[Service]
ExecStartPre=/sbin/iw dev %i interface add ap@%i type __ap
ExecStart=/usr/sbin/hostapd -i ap@%i /etc/hostapd/hostapd.conf
ExecStopPost=-/sbin/iw dev ap@%i del

[Install]
WantedBy=sys-subsystem-net-devices-%i.device
EOF

cat > ${ROOTFS_DIR}/etc/systemd/network/08-wifi.network <<EOF
[Match]
Name=wl*
[Network]
LLMNR=no
MulticastDNS=yes
# If you need a static ip address, then toggle commenting next four lines (example)
DHCP=ipv4
#Address=192.168.50.60/24
#Gateway=192.168.50.1
#DNS=84.200.69.80 1.1.1.1
EOF

cat > ${ROOTFS_DIR}/etc/systemd/network/12-ap.network  <<EOF
[Match]
Name=ap@*
[Network]
LLMNR=no
MulticastDNS=yes
IPMasquerade=yes
Address=192.168.4.1/24
DHCPServer=yes
[DHCPServer]
DNS=84.200.69.80 1.1.1.1

EOF

on_chroot <<EOF
systemctl enable accesspoint@wlan0.service
EOF
