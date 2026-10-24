#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find -L . -name "*-lrg.jpg" -or -name "*-med.jpg" | grep -F -v pb > err_pb.txt
