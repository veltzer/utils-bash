#!/bin/bash

for x in *; do
	if [[ -d "$x/.git" ]]; then
		echo -n "doing [$x]: "
		cd $x
		#git log --format='%aN' | sort -u
		git log --format='%aN' | sort -u | wc -l
		cd ..
	fi
done
