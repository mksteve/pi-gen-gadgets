#!/bin/bash -e

wget http://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree/firmware-brcm80211_20190114-1+rpt4_all.deb
dpkg --purge firmware-brcm80211
dpkg --install firmware-brcm80211_20190114-1+rpt4_all.deb
apt-mark hold firmware-brcm80211
rm firmware-brcm80211_20190114-1+rpt4_all.deb
