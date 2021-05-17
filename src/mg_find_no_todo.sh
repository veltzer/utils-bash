#!/bin/bash
for x in py*
do
	if [ ! -f "$x/doc/TODO.txt" ]
	then
		echo "$x"
	fi
done
