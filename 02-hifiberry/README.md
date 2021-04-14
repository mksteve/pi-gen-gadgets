Simple gadget to add correct hifiberry card to config.txt

config - the following lines need to be added to pi-gen config

SOUNDCARD=<sndcard>
export SOUNDCARD


See : https://www.hifiberry.com/docs/software/configuring-linux-3-18-x/


where <sndcard> is one of the hifiberry cards.
e.g. hifiberry-dacplusadcpro | hifiberry-dac | hifiberry-dacplus | hifiberry-dacplushd | hifiberry-dacplusadc
