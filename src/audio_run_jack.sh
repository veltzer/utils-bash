#!/bin/bash -eu

: <<'COMMENT'

This script loads the relevant kernel modules for jack and then runs jack

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

killall jackd
sleep 3
# lets load the raw module (if it is already in no harm done)
modprobe raw1394
# shellcheck source=/dev/null
source ~/.jackdrc &
