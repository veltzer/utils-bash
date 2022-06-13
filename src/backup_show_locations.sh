#!/bin/bash -e

# set -x
# you can add int_corsair
for x in ext_wd ext_wd_large ext_seagate
do
	ls -l /mnt/$x/mark/backups
done
