#!/bin/bash

SSH="elec"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
URL=http://milhouse.libreelec.tv/builds/master/RPi2/
VERSION=kodi.version

CURRENT=`cat $DIR/$VERSION`
NEXT=`curl -sf $URL | tail -2 | head -1 | sed 's/^.*href=\"\(.*\)\".*$/\1/'`

if [ $? != 0 ]; then
    echo "cannot access $URL"
    exit 1
fi
if [ "$CURRENT" != "$NEXT" ]; then
    ssh $SSH curl -# -o .update/$NEXT $URL$NEXT
    ssh $SSH '{ sleep 1; reboot; } > /dev/null &'
    echo $NEXT > $DIR/$VERSION
else
    echo "already up to date"
fi
