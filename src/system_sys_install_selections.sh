#!/bin/bash

<<'COMMENT'

This script clones the package selections that have been on some
other machine to the machine this is run on...

use it as sudo ./install_selections [selections file]

COMMENT

if test $USER != 'root';then
	echo "run me as root..."
	exit 1
fi

if test $# -ne 1; then
	echo "usage ./install_selections [selections file]"
	exit 1
fi
selection=$1
if test ! -r $selection; then
	echo "selection file is invalid"
	exit 1
fi

apt-get update
apt-get dist-upgrade
apt-get install dselect
dpkg --set-selections < $1
dselect install
dselect remove
