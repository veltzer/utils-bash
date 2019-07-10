#!/bin/bash

# this checks that the files are of the right type
echo "Checking that all are of the right suffix"
find by_name -mindepth 2 -type f -and -not -name "*.avi" -and -not -name "*.m4v" -and -not -name "*.mp4" -and -not -name "*.wmv" -and -not -name "*.mov" -and -not -name "*.flv"
# this checks for permissions other than 444
echo "Permission problems"
find by_name -mindepth 2 -type f -and -not -perm 444
echo "directory problems"
find by_name -mindepth 4 -type f
find by_name -mindepth 1 -maxdepth 2 -type f
