#!/bin/bash

for x in *; do
	if [[ -d "$x/.git" ]]; then
		echo "doing [$x]"
		cd $x
		git gc
		cd ..
	fi
done
