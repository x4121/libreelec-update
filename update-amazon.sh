#!/bin/bash

SSH="elec"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SUB=xbmc-amazon
PACKAGES=$SUB/packages/
VERSION=amazon.version
PLUGIN=plugin.video.amazon-test
TAR=$PLUGIN.tar.gz
KODI=.kodi/addons

pushd $DIR >&- 2>&-

ls $PACKAGES > /dev/null 2> /dev/null
if [ $? != 0 ]; then
    echo "cloning submodule"
    git submodule update --init --recursive >&- 2>&-
fi
if [ $? != 0 ]; then
    echo "cannot access submodule"
    popd >&- 2>&-
    exit 1
fi

git submodule update --remote --merge --recursive >&- 2>&-
CURRENT=`cat $VERSION 2>&-`
NEXT=`git submodule | grep $SUB | cut -d' ' -f2`

if [ "$CURRENT" != "$NEXT" ]; then
    tar -czf $TAR -C $PACKAGES $PLUGIN
    scp $TAR $SSH:.
    ssh $SSH rm -rf $KODI/$PLUGIN
    ssh $SSH tar -xzf $TAR -C $KODI
    ssh $SSH rm $TAR
    ssh $SSH unzip -d $KODI -o $KODI/$PLUGIN/*.zip
    rm $TAR
    echo $NEXT > $VERSION
else
    echo "already up to date"
fi

popd >&- 2>&-
