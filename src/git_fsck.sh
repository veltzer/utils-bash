#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in *
do
	if [[ -d "${x}" ]]
	then
		echo "doing [${x}]"
		cd "${x}" || exit
		(
			git fsck
		)
	fi
done
