#!/bin/bash

SSH="elec"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUGIN=plugin.video.amazon-test
TAR=$DIR/$PLUGIN.tar.gz
KODI=.kodi/addons

tar -czf $TAR -C $DIR/xbmc-amazon/packages/ $PLUGIN
scp $TAR elec:.
ssh $SSH rm -rf $KODI/$PLUGIN
ssh $SSH tar -xzf $TAR -C $KODI
ssh $SSH rm $TAR
ssh $SSH unzip -d $KODI -o $KODI/$PLUGIN/*.zip
rm $TAR
