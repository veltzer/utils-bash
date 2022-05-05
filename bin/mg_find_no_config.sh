#!/bin/bash -e
for x in py*
do
	if [ ! -d "$x/config" ]
	then
		echo "$x"
	fi
done
