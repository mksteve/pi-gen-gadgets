install -m 644 files/jamulus.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -m 755 -d "${ROOTFS_DIR}/usr/local/share/keyrings/"
install -m 644 files/qpc-guitar.gpg "${ROOTFS_DIR}/usr/local/share/keyrings/"
install -m 755 --owner 1000 --group 1000 files/runjack.sh "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runjack.sh"
install -m 755 files/runjack "${ROOTFS_DIR}/usr/local/bin/runjack"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/jamulus.list"

on_chroot <<EOF
apt-get update
apt-get install jamulus
su - pi -c 'echo ${JACKDRC} > ~/.jackdrc'
EOF
