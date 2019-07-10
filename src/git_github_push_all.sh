#!/bin/bash

for x in *; do
	if [[ -d "$x/.git" ]]; then
		echo "doing [$x]"
		cd $x
		#git push --tags
		git push
		cd ..
	fi
done
