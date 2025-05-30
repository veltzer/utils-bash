#!/bin/bash -eu

# this script generated a video from the git repository it is run in...

# check that we have gource installed and in our path
if ! command -v gource &> /dev/null
then
	echo "gource could not be found, please install it and make sure it is in your path"
	exit 1
fi
xvfb-run -a -s "-screen 0 1280x720x24" \
	gource \
	--output-ppm-stream - \
	--output-framerate 30 \
	--title "History of git repo" \
	--seconds-per-day 0.01 \
	| ffmpeg -y -f image2pipe -vcodec ppm -i - movie.mp4
