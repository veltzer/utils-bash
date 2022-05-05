#!/bin/bash -e
for x in py*
do
	if grep -L no_there "$x/.idea/$x.iml" > /dev/null
	then
		echo "$x/.idea/$x.iml"
	fi
done
