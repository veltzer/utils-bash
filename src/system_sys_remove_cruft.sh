#!/bin/bash

<<'COMMENT'

This script cleans up package manager cruft on your system...
three things it does:
1. purge package which are removed but NOT purged.
2. autoremove any leftover packages.
3. remove deb packages from the package cache that can no longer be downloaded.

COMMENT

#if test $USER != 'root';then
#	echo "run me as root..."
#	exit 1
#fi

# count number of rc packages...
count=`dpkg --list | grep "^rc" | tr -s " " | cut -d " " -f 2 | wc -l`
# make sure that there are packages like that...
if test $count -gt 0; then
	# this purges removed but not purge packages...
	sudo dpkg --purge `dpkg --list | grep "^rc" | tr -s " " | cut -d " " -f 2`
else
	echo "you do not have any rc package..."
fi
sudo apt-get autoremove
sudo apt-get autoclean
