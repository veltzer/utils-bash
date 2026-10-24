#!/bin/bash -eu

: <<'COMMENT'

This script kills jack

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

killall jackd
