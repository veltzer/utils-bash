#!/bin/bash

# we need to be run as root...
if test $USER != 'root';then
	echo "run me as root..."
	exit 1
fi

# params...
# where is the gitweb cache directory...
DIR=/var/cache/git
# these are the repositories I want to publicize...
names="demos"

# here we go...

# first lets remove the old links...
rm -f $DIR/*
#sudo rm -f `find $DIR -type l`

# recreate the links...
for x in $names; do
	if [[ -d ${x}.git ]]; then
		echo "doing link for [$x]"
		ln -s /home/mark/git/repos/${x}.git ${DIR}/${x}.git
	else
		echo "the project [$x] could not be found"
	fi
done
