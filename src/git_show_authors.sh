#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in *
do
	if [[ -d "${x}/.git" ]]
	then
		echo -n "doing [${x}]: "
		cd "${x}" || exit
		#git log --format='%aN' | sort -u
		authors=$(git log --format='%aN' || true)
		unique_authors=$(sort -u <<< "${authors}")
		if [[ -z "${unique_authors}" ]]
		then
			echo 0
		else
			wc -l <<< "${unique_authors}"
		fi
		cd ..
	fi
done
