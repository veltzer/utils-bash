#!/bin/bash

<<'COMMENT'

TODO:
- check that track names are of the right style and unified all over
- check that mp3 info matches the directory structure.
- unify some of the checks here to run faster
- cover art using cddb ids ? dreaming ?
- check what to do about the m4a files. Are they good ?

This script was supposed to be replaced by the java code but the java code
is not yet working properly so this is the right code for now.

COMMENT

# first check that we are in the right folder
if [[ ! -d by_name ]];then
	echo "put me in the folder where by_name is..."
	exit 1
fi

# this checks that the files are of the right type
echo "name problems"
find . -mindepth 2 -type f -and -not -name "*.mp3"
# these next two check that the directory structure is exact
echo "directory problems"
find by_name -mindepth 4 -type f
find by_name -mindepth 1 -maxdepth 2 -type f
# this checks for permissions other than 444
#find . -mindepth 2 -and -type f -and -not -perm 444
echo "permission problems"
find . -mindepth 2 -and -type f -and -not -perm 644
