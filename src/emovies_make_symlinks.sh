#!/bin/bash -eu

: <<'COMMENT'

This script will create symlinks so that you could access a piece by it's name only...

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# remove all old links...
rm -f by_title_name/*
for x in by_name/*/* by_organization/*/*
do
	if [[ -d "${x}" ]]
	then
		y="$(basename "${x}")"
		ln -s "../${x}" "by_title_name/${y}"
	fi
done
