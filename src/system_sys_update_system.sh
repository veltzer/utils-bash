#!/bin/bash -eu

: <<'COMMENT'

This script updates your system

COMMENT

FIX_MISSING="0"

#if test $USER != 'root'
#then
#	echo "run me as root..."
#	exit 1
#fi

# this is wrong - look up how to do this in bash
#sudo apt-get update 2|1 grep -v "uses weak digest algorithm"
sudo apt-get update
# sudo apt-get -y dist-upgrades
# sudo apt-get -y full-upgrade
# this will install kept back packages as well
if [ "${FIX_MISSING}" == "1" ]
then
	sudo aptitude -y safe-upgrade -o "APT::Get::Fix-Missing=true"
	sudo apt-get -y upgrade --fix-missing
else
	sudo aptitude -y safe-upgrade
	sudo apt-get -y upgrade
fi
# sudo aptitude -y full-upgrade
# sudo apt-get --with-new-pkgs upgrade
