#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

PAGER=gh run list --repo veltzer/demos-os-linux --limit 1 --json conclusion --jq '.[0].conclusion'
