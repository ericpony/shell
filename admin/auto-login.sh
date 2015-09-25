#! /bin/bash

USER=
PASS=
LOGIN=

URL="https://$USER:$PASS@$LOGIN"

DELAY=0
#DELAY=$(shuf -i 100-7200 -n 1) # random delay up to 2 hours

CREDENTIAL=$(curl -s $URL | sed -n 's/^.*name="\([^"]*\)" value="\([^"]*\)".*$/\1=\2/gp' | tr "\n" '&')

echo "sleep $DELAY; curl -s '$URL' --data '$CREDENTIAL' >> /tmp/autologin.log" | bash &
