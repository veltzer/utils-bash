#!/bin/bash -eu

: <<'COMMENT'

This script checks that there is no diff in the package selections

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

diff dpkg_selections.*
