#!/bin/bash -eu

# only get the selections...

# this script does not have to run as root
#if test $USER != 'root'
#then
#	echo "run me as root..."
#	exit 1
#fi

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

HOSTNAME="$(hostname)"
dpkg --get-selections  > dpkg_selections."${HOSTNAME}".txt
