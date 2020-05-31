#!/bin/bash

cd /opt/calibre

TORUN="./calibre-server --userdb /config/users.sqlite --enable-auth"

if [ -z "$(ls -A /library)" ];
then
    echo "Making new library..."
    xvfb-run calibredb list --library-path=/library > /dev/null
fi

if [ ! -f /config/users.sqlite ];
then
    echo "Making new users database..."
    ./calibre-server --userdb /config/users.sqlite --manage-users
fi

TORUN="$TORUN /library"
echo -e "\n$TORUN $@"
exec $TORUN $@
