#!/bin/bash

<<'COMMENT'

This script loads the relevant kernel modules for jack and then runs jack

COMMENT

killall jackd
sleep 3
# lets load the raw module (if it is already in no harm done)
modprobe raw1394
source ~/.jackdrc &
