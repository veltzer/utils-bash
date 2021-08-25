#!/bin/bash -e
for x in py*
do
	if [ ! -d "$x/tests" ]
	then
		echo "$x"
	fi
done
