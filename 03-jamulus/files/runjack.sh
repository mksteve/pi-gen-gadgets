#/bin/bash -e
echo runjack.sh
if aplay -l | grep 'USB Audio CODEC' ; then
    /usr/bin/jackd -P75 -dalsa -r48000 -p64 -n16 -Chw:CODEC -Phw:CODEC,0
elif aplay -l | grep 'UMC202HD 192k' ; then
    /usr/bin/jackd -P75 -dalsa -r48000 -p64 -n16 -Chw:U192k -Phw:U192k,0
else
    /usr/bin/jackd -P75 -dalsa -r48000 -p64 -n16 -Chw:sndrpihifiberry -Phw:sndrpihifiberry,0
fi

