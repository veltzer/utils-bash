#!/bin/bash -e

: <<'COMMENT'

This script converts everything you give it to mp3 using ffmpeg.

TODO:
the brand 'mp42' is hardcoded in this script. I readlly should be able
to scrape that brand from an existing file and provide a functionality like:
	$ video_to_mp4.sh --take-brand-from [example.mp4] [list of files to be converted]
Maybe this will require to convert this script into python.

COMMENT

for input in "$@"
do
	output=${input%.*}.mp4
	ffmpeg -i "$input" -brand mp42 "$output"
done
