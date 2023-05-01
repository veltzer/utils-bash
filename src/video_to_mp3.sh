#!/bin/bash -e

: <<'COMMENT'

This script converts everything you give it to mp3 using ffmpeg.

COMMENT

for input in "$@"
do
	output="${input%.*}.mp3"
	ffmpeg -i "${input}" "${output}"
done
