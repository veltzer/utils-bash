#!/bin/bash -eu

# first check that we are in the right folder
if [[ ! -d by_name ]]
then
	echo "put me where by_name is..."
	exit 1
fi

FOLDERS=(
	"by_name"
	"by_organization"
	"unsorted"
)
# this checks that the files are of the right type
echo "Checking that all are mp3"
find "${FOLDERS[@]}" -mindepth 1 -type f -and -not -name "*.mp3"
# this checks for permissions other than 444
echo "Files which are not 444"
find "${FOLDERS[@]}" -mindepth 1 -type f -and -not -perm 444
echo "Folders which are not 775"
find "${FOLDERS[@]}" -type d -and -not -perm 775
echo "Files too deep"
find "${FOLDERS[@]}" -mindepth 4
