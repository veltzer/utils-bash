#!/bin/bash -e

: <<'COMMENT'

This script finds all video files in the current folder.

COMMENT

if [ "$#" -gt 1 ]
then
	echo "$0: use with at most one argument [level=1]"
	exit 1
fi

if [ "$#" -eq 0 ]
then
	depth=1
else
	depth=$1
fi

find . \
-mindepth "$depth" \
-type f \
-and \(
-or -name "*.avi" \
-or -name "*.flv" \
-or -name "*.wmv" \
-or -name "*.mpg" \
-or -name "*.asf" \
-or -name "*.mpeg" \
-or -name "*.rm" \
-or -name "*.mov" \
-or -name "*.mkv" \
-or -name "*.3gp" \
-or -name "*.ram" \
-or -name "*.m4v" \
-or -name "*.rmvb" \
-or -name "*.qt" \
-or -name "*.mp4" \
-or -name "*.VOB" \
-or -name "*.mts" \
-or -name "*.webm" \
-or -name "*.vid" \
-or -name "*.m3u" \
-or -name "*.m4a" \
\)
