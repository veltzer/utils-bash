#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# start the gnome keyring daemon (otherwise it complains constantly...)
killall -9 gnome-keyring-daemon
/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg
