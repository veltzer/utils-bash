#!/bin/bash -e

# backup your home directory excluding folders which have a .NOBACKUP file in them

temp="/tmp/homdir.tar.gz"
target="${HOME}/homdir.tar.gz"

if [ -f "${target}" ]
then
	echo "removing backup already in your homedir"
	rm "${target}"
fi
cd "${HOME}" 
tar --create --gzip --file "${temp}" --exclude-tag-all=.NOBACKUP .
mv "${temp}" "${target}" 
echo "your backup is in your homedir"
