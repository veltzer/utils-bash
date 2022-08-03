#!/bin/bash -e

: <<'COMMENT'

This script updates your system

COMMENT

#if test $USER != 'root'
#then
#	echo "run me as root..."
#	exit 1
#fi

# this is wrong - look up how to do this in bash
#sudo apt-get update 2|1 grep -v "uses weak digest algorithm"
sudo apt-get update
# sudo apt-get -y dist-upgrades
sudo apt-get -u full-upgrade
# sudo aptitude -y full-upgrade
# sudo apt-get --with-new-pkgs upgrade
