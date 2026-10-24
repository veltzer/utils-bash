#!/bin/bash -eu

: <<'COMMENT'

This will select the version of java you want using the alternative system.

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

sudo update-java-alternatives --list
sudo update-java-alternatives --set
sudo update-java-alternatives --set java-1.22.0-openjdk-amd64
