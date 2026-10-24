#!/bin/bash -eu

: <<'COMMENT'

Show which java versions we have installed

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# update-alternatives  --list java
update-java-alternatives --list
