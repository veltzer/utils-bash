#!/bin/bash

# start the gnome keyring daemon (otherwise it complains constantly...)
killall -9 gnome-keyring-daemon
/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg
