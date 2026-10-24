#!/bin/bash -eu

: <<'COMMENT'

This script shows you what jdk/jre java versions are there in the ubuntu repository.

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

apt-cache search openjdk | grep -- -jdk
