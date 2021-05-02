#!/bin/bash -e
install -m 755 -d "${ROOTFS_DIR}/home/pi/.config/systemd/user"
install -m 644 files/jamulus.service "${ROOTFS_DIR}/home/pi/.config/systemd/user/jamulus.service"
install -m 644 files/update.service "${ROOTFS_DIR}/home/pi/.config/systemd/user/update.service"
install -m 755 files/autoupdate.sh  "${ROOTFS_DIR}/home/pi/autoupdate.sh"

install -m 755 -d  "${ROOTFS_DIR}/home/pi/.config/systemd/user/default.target.wants"
sed -i "s/_JAMULUS_IP_/${JAMULUS_IP}/g" "${ROOTFS_DIR}/home/pi/.config/systemd/user/jamulus.service"
sed -i "s/_JAMULUS_CLIENT_/${JAMULUS_CLIENT}/g" "${ROOTFS_DIR}/home/pi/.config/systemd/user/jamulus.service"

on_chroot <<EOF
chown pi /home/pi/.config/systemd/user/jamulus.service
chown pi /home/pi/.config/systemd/user/update.service
chown pi /home/pi/.config/systemd/user /home/pi/.config/systemd
chown pi /home/pi/.config
chown pi /home/pi/.config/systemd/user/default.target.wants
chgrp pi /home/pi/.config/systemd/user/jamulus.service
chgrp pi /home/pi/.config/systemd/user/update.service
chgrp pi /home/pi/.config/systemd/user /home/pi/.config/systemd
chgrp pi /home/pi/.config
chgrp pi /home/pi/.config/systemd/user/default.target.wants
ln -s /home/pi/.config/systemd/user/jamulus.service /home/pi/.config/systemd/user/default.target.wants/jamulus.service
ln -s /home/pi/.config/systemd/user/update.service /home/pi/.config/systemd/user/default.target.wants/update.service
chown pi /home/pi/.config/systemd/user/default.target.wants/jamulus.service
chgrp pi /home/pi/.config/systemd/user/default.target.wants/jamulus.service
chown pi /home/pi/.config/systemd/user/default.target.wants/update.service
chgrp pi /home/pi/.config/systemd/user/default.target.wants/update.service

chown pi /home/pi/autoupdate.sh
chgrp pi /home/pi/autoupdate.sh
EOF

