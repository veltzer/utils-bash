#!/bin/bash

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

gh release view --json assets --jq '.assets[] | "\(.name)\t\(.size)\t\(.downloadCount)"' | column -t -N NAME,SIZE,DOWNLOADS
