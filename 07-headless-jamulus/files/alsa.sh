sha_value=`aplay -l |  grep '^card [0-9]*' | sha256sum | cut -c -8`
alsa_done=true
#
#
#  This script is available to override the jackd configuration when custom hardware is added.
# 1) plug in hardware to the raspberry pi
# 2) reboot
# 3)
# go to the local website for the box (http://127.0.0.1/status or http://192.168.4.1/status)
# make a note of the sha256:8 value at the bottom, and the alsa names
# The value 'xxxxxxxx' needs to be replaced with the sha256:8 value, and the required capture device (C), and playback device (P)
#
# **** List of PLAYBACK Hardware Devices ****
#card 0: sndrpihifiberry [snd_rpi_hifiberry_dacplusadc], device 0: HiFiBerry DAC+ADC HiFi multicodec-0 [HiFiBerry DAC+ADC HiFi multicodec-0]
#  Subdevices: 1/1
#  Subdevice #0: subdevice #0
#card 1: CODEC [USB Audio CODEC], device 0: USB Audio [USB Audio]
#  Subdevices: 1/1
#  Subdevice #0: subdevice #0
#
#e.g.
#card 0: <RequiredCapture>
#card 1: <RequiredPlayback>
#
#
# a suitable command would be something like....
# /usr/bin/jackd -P75 -dalsa -r48000 -p64 -n16 -Chw:sndrpihifiberry -Phw:CODEC

if [ ${sha_value} == 'xxxxxxxx' ]; then
   /usr/bin/jackd -P75 -dalsa -r48000 -p64 -n16 -Chw:CODEC -Phw:CODEC
elif [ ${sha_value} == 'yyyyyyyy' ]; then
   /usr/bin/jackd -P75 -dalsa -r48000 -p64 -n16 -Chw:CODEC -Phw:CODEC
else
   alsa_done=false
fi
