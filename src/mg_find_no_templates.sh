#!/bin/bash
for x in py*
do
	if [ ! -d "$x/templates" ]
	then
		echo "$x"
	fi
done
