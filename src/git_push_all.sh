#!/bin/bash

for x in *
do
	if [[ -d "$x/.git" ]]
	then
		echo "doing [$x]"
		(
		cd "$x" || exit
		#git push --tags
		git push
		)
	fi
done
