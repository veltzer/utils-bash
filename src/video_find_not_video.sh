#!/bin/bash -eu

: <<'COMMENT'

This script finds all files under the current folder which are not video files.
You can pass a depth parameter to it

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
-mindepth "${depth}" \
-type f \
-and -not -name "*.avi" \
-and -not -name "*.flv" \
-and -not -name "*.wmv" \
-and -not -name "*.mpg" \
-and -not -name "*.asf" \
-and -not -name "*.mpeg" \
-and -not -name "*.rm" \
-and -not -name "*.mov" \
-and -not -name "*.mkv" \
-and -not -name "*.3gp" \
-and -not -name "*.ram" \
-and -not -name "*.m4v" \
-and -not -name "*.rmvb" \
-and -not -name "*.qt" \
-and -not -name "*.mp4" \
-and -not -name "*.VOB" \
-and -not -name "*.mts" \
-and -not -name "*.webm" \
-and -not -name "*.vid" \
-and -not -name "*.m3u" \
-and -not -name "*.webp" \
-and -not -name "*.m4a"
