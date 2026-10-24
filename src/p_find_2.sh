#!/bin/bash -eu

: <<'COMMENT'

Find folders with _2, _3, ...

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find . -mindepth 3 -maxdepth 3 -name "*_2" > err_2.txt
find . -mindepth 3 -maxdepth 3 -name "*_3" >> err_2.txt
find . -mindepth 3 -maxdepth 3 -name "*_4" >> err_2.txt
