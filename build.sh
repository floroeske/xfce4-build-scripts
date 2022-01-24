#!/bin/bash

set -e

MODULES=""
while IFS= read -r LINE; do
    if [[ $LINE =~ ^#.* ]]
    then
        echo Skipping $LINE
    else
        MODULES+=" $LINE"
    fi
done < modules.txt

PREFIX=/usr/local
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-O2 -pipe"
DIR=$HOME/xfce4-build/src
pushd $DIR

# cmake -DCMAKE_INSTALL_PREFIX=/usr

for MODULE in ${MODULES};
do
    IFS=';';
    set -- $MODULE
    unset IFS

    GROUP=$1
    REPO=$2
    BUILDSYSTEM=$3

    echo MODULE ${MODULE}
    echo GROUP $GROUP
    echo REPO $REPO
    echo BUILDSYSTEM $BUILDSYSTEM

    pushd ${REPO}
    make -j `nproc`
    popd
done

echo
echo "Success"
