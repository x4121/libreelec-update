#!/bin/bash

SSH="elec"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SUB=xbmc-amazon
PACKAGES=$SUB/packages/
VERSION=amazon.version
PLUGIN=plugin.video.amazon-test
TAR=$PLUGIN.tar.gz
KODI=.kodi/addons

pushd "$DIR" >&- 2>&-

if ! ls $PACKAGES >/dev/null 2>&1; then
    echo "cloning submodule"
    if ! git submodule update --init --recursive >/dev/null 2>&1; then
        echo "cannot access submodule"
        popd >&- 2>&-
        exit 1
    fi
fi

git submodule update --remote --merge --recursive >&- 2>&-
CURRENT=$(ssh $SSH cat $VERSION)
NEXT=$(cat .git/modules/$SUB/HEAD)

if [[ $CURRENT != "$NEXT" ]]; then
    tar czf $TAR -C $PACKAGES $PLUGIN
    scp $TAR $SSH:.
    # shellcheck disable=2029
    ssh $SSH "rm -rf $KODI/$PLUGIN \
          && tar xzf $TAR -C $KODI \
          && rm $TAR \
          && unzip -d $KODI -o $KODI/$PLUGIN/*.zip \
          && echo $NEXT > $VERSION"
    rm $TAR
else
    echo "already up to date"
fi

popd >&- 2>&-
