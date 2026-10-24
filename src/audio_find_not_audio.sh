#!/bin/bash -eu

: <<'COMMENT'

This script finds all files under the current folder which are not audio files.

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find . \
-mindepth 2 \
-type f \
-and \( \
-not -name "*.mp3" \
-and -not -name "*.m3u" \
-and -not -name "*.m4b" \
-and -not -name "*.ogg" \
-and -not -name "*.m4a" \)
