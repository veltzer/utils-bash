#!/bin/bash -eu

: <<'COMMENT'

This script cleans up package manager cruft on your system...
three things it does:
1. purge package which are removed but NOT purged.
2. autoremove any leftover packages.
3. remove deb packages from the package cache that can no longer be downloaded.

COMMENT

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# count number of rc packages...
dpkg_list=$(dpkg --list)
rc_packages=$(awk '/^rc/ {print $2}' <<< "${dpkg_list}")
# make sure that there are packages like that...
if [[ -n "${rc_packages}" ]]
then
	# this purges removed but not purge packages...
	readarray -t packages <<< "${rc_packages}"
	sudo dpkg --purge "${packages[@]}"
else
	echo "you do not have any rc package..."
fi
sudo apt-get autoremove -y
sudo apt-get autoclean -y
