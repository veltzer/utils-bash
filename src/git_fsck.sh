#!/bin/bash -eu

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
