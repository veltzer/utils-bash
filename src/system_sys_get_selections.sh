#!/bin/bash

# only get the selections...

# this script does not have to run as root
#if test $USER != 'root';then
#	echo "run me as root..."
#	exit 1
#fi

HOSTNAME=`hostname`
dpkg --get-selections  > dpkg_selections.$HOSTNAME.txt
