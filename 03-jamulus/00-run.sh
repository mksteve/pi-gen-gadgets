install -m 644 files/jamulus.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -m 755 -d "${ROOTFS_DIR}/usr/local/share/keyrings/"
install -m 644 files/repo.gpg "${ROOTFS_DIR}/usr/local/share/keyrings/"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/jamulus.list"

on_chroot <<EOF
apt-get update
apt-get install jamulus
su - pi -c 'echo ${JACKDRC} > ~/.jackdrc'
EOF
