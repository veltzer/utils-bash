#!/bin/bash -e

: <<'COMMENT'

This script updates your system

COMMENT

FIX_MISSING="0"
if [ "${FIX_MISSING}" == "1" ]
then
	ARGS_APTITUDE="-o APT::Get::Fix-Missing=true"
	ARGS_APT_GET="--fix-missing"
else
	ARGS_APTITUDE=""
	ARGS_APT_GET=""
fi

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
sudo aptitude -y safe-upgrade "${ARGS_APTITUDE}"
sudo apt-get -y upgrade "${ARGS_APT_GET}"
# sudo aptitude -y full-upgrade
# sudo apt-get --with-new-pkgs upgrade
