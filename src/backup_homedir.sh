#!/bin/bash -eu

: <<'COMMENT'

backup your home directory excluding folders which have a .NOBACKUP file in them
Note the --exclude-tag flag when calling "tar"
read about all the "--exclude-tag*" flags and see why this is the best one

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

temp="/tmp/homedir.tar.gz"
target_dir="${HOME}/backups"
target="${target_dir}/homedir.tar.gz"

if [ -f "${target}" ]
then
	echo "removing backup already in your homedir"
	rm "${target}"
fi
cd "${HOME}" 
tar --create --gzip --file "${temp}" --exclude-tag=.NOBACKUP .
mv "${temp}" "${target}" 
echo "your backup is in ${target}"
