#!/bin/bash -e
for x in *
do
	if [ -d "$x/.git" ]
	then
		cd "$x" || exit
		branch=$(git branch --show-current)
		if [ "$branch" != "master" ]
		then
			echo "$x local $branch"
		fi
		remote=$(git branch -r -q --show-current)
		if [ "$remote" != "master" ]
		then
			echo "$x remote $branch"
		fi
		num_branches=$(git branch | wc -l)
		if [ "$num_branches" != "1" ]
		then
			echo "$x $num_branches"
		fi
		cd ..
	fi
done
