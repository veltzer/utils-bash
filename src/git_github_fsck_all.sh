#!/bin/bash

for x in *; do
	if [[ -d $x ]]; then
		echo "doing [$x]"
		cd $x
		git fsck
		cd ..
	fi
done
