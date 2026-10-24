#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# This will upgrade all the pip modules that can be upgraded
pip list --outdated --format=columns | cut -d " " -f 1 | xargs -n1 pip install --upgrade
