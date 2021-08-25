#!/bin/bash
if [[ $# -gt 1 ]]
then
	echo "You must pass at most one argument to this script..."
	exit 1
fi
if [[ $# -eq 1 ]]
then
	msg="$1"
else
	msg="commit message"
fi
git commit -am "${msg}"
git push
