#!/bin/bash
ERRFILE=errors.txt
echo "Resetting the $ERRFILE file"
# reset the errors file
echo -n > $ERRFILE
# this checks that the files are of the right type
echo "Checking that all files are of a known suffix"
find -L . -mindepth 2 -type f -and -not \( -name "*.mov" -or -name "*.mpg" -or -name "*.avi" -or -name "*.rm" -or -name "*.asf" -or -name "*.wmv" -or -name "*.ram" -or -name "*.rmvb" -or -name "*.qt" -or -name "*.3gp" -or -name "*.flv" -or -name "*.mp4" -or -name "*.mpeg" -or -name "*.ogg" -or -name "*.ogv" \) >> $ERRFILE
# this checks for permissions other than 444
echo "Checking for permission problems"
find -L . -mindepth 2 -type f -and -not -perm 444 >> $ERRFILE
