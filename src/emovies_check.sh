#!/bin/bash -eu

if [ ! -d by_name ]
then
	echo "Put me in the right folder"
	exit 1
fi

# this checks that the files are of the right type
echo "Checking that all are of the right suffix"
find by_name -mindepth 2 -type f -and -not -name "*.avi" -and -not -name "*.m4v" -and -not -name "*.mp4" -and -not -name "*.wmv" -and -not -name "*.mov" -and -not -name "*.flv" -and -not -name "*.mkv" -and -not -name "*.webm" -and -not -name "link.txt"
# this checks for permissions other than 444
echo "Permission problems (not 444)"
find by_name -mindepth 2 -type f -and -not -perm 444
echo "directory problems"
find by_name -mindepth 4 -type f
find by_name -mindepth 1 -maxdepth 2 -type f
