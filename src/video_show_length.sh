#!/bin/bash -e

: <<'COMMENT'

This script receives video files on the command line and displays their length

COMMENT

for vid in "$@"
do
	echo -n "${vid} "
	ffprobe -v quiet -of csv=p=0 -show_entries format=duration "${vid}"
done
