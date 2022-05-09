#!/bin/bash -e
for x in *
do
	if [ -d "$x/.git" ]
	then
		cd "$x" || exit
		if [ -f ".github/workflows/build.yml" ] && [ ! -f "templates/.github/workflows/build.yml.mako" ]
		then
			echo "$x"
		fi
		cd ..
	fi
done
