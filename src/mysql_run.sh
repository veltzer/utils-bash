#!/bin/bash -e
if [[ $# -ne 1 ]]
then
	echo "usage: $0 [file.sql]"
	exit 1
fi

filename=$1
mysql < "${filename}"
