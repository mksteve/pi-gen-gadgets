
on_chroot <<EOF
  sudo config-edit --add dtoverlay=${SOUNDCARD}
  sudo config-edit --comment 'dtparam=audio=on'
EOF


