#!/bin/bash -e

# from https://raspberrypi.stackexchange.com/questions/108592/use-systemd-networkd-for-general-networking/108593#108593
# remove debian components, and mark them unwanted.
BACKUP_DIR=/var/systemd-nw-bak

function do_systemd_install {
    apt-get -y autoremove ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog
    apt-mark  hold ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog raspberrypi-net-mods openresolv
    apt-get -y install  --download-only libnss-resolve
    [ -d ${BACKUP_DIR} ] ||  mkdir ${BACKUP_DIR}
    # one of these commands breaks networking AND name resolution, so
    # we have to pre download libnss-resolve
    [ -d /etc/dhcp ]    && mv /etc/dhcp ${BACKUP_DIR}/
    [ -d /etc/network ] && mv /etc/network ${BACKUP_DIR}
    [ -f /etc/resolv.conf -a ! -f ${BACKUP_DIR}/resolv.conf ] &&
	mv /etc/resolv.conf ${BACKUP_DIR}/resolv.conf
    WPA_COUNTRY=
    [ -f /etc/wifi-country ] && WPA_COUNTRY=$( cat /etc/wifi-country )
    # setup/enable systemd-resolved and systemd-networkd
    apt-get -y autoremove avahi-daemon
    apt-mark hold avahi-daemon libnss-mdns
    apt install -y libnss-resolve
    ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

    if [ ! -f /etc/systemd/network/04-wired.network ] ; then
	cat > /etc/systemd/network/04-wired.network <<EOF
[Match]
Name=e*

[Network]
## Uncomment only one option block
# Option: using a DHCP server and multicast DNS
LLMNR=no
LinkLocalAddressing=no
MulticastDNS=yes
DHCP=ipv4

# Option: using link-local ip addresses and multicast DNS
#LLMNR=no
#LinkLocalAddressing=yes
#MulticastDNS=yes

# Option: using static ip address and multicast DNS
# (example, use your settings)
#Address=192.168.50.60/24
#Gateway=192.168.50.1
#DNS=84.200.69.80 1.1.1.1
#MulticastDNS=yes
EOF
    fi
    if [ ! -f /etc/systemd/network/08-wifi.network ] ; then
	cat > /etc/systemd/network/08-wifi.network <<EOF
[Match]
Name=wl*

[Network]
## Uncomment only one option block
# Option: using a DHCP server and multicast DNS
LLMNR=no
LinkLocalAddressing=no
MulticastDNS=yes
DHCP=ipv4

# Option: using link-local ip addresses and multicast DNS
#LLMNR=no
#LinkLocalAddressing=yes
#MulticastDNS=yes

# Option: using static ip address and multicast DNS
# (example, use your settings)
#Address=192.168.50.61/24
#Gateway=192.168.50.1
#DNS=84.200.69.80 1.1.1.1
#MulticastDNS=yes
EOF
    fi
    if [ ! -f /etc/wpa_supplicant/wpa_supplicant-wlan0.conf ] ; then
	cat > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf <<EOF
country=_WPA_COUNTRY_
ctrl_interface=DIR=/run/wpa_supplicant GROUP=netdev
update_config=1

EOF
	sed -i "s/_WPA_COUNTRY_/${WPA_COUNTRY}/g"   "/etc/wpa_supplicant/wpa_supplicant-wlan0.conf"

    fi
    chmod 600 /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
    systemctl disable wpa_supplicant.service
    systemctl enable wpa_supplicant@wlan0.service
    rfkill unblock wlan
    
    systemctl enable systemd-networkd.service systemd-resolved.service
}
if [ "$1" == "--force" ] ; then
    do_systemd_install
elif systemctl is-active --quiet systemd-networkd.service ; then
    echo "systemd-networkd.service is already active"
else
   do_systemd_install 
fi
