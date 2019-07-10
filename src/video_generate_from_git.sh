#!/bin/sh

# this script generated a video from the git repository it is run in...

xvfb-run -a -s "-screen 0 1280x720x24" \
	gource \
	--output-ppm-stream - \
	--output-framerate 30 \
	--title "History of shopymate git repo" \
	--seconds-per-day 0.01 \
	| ffmpeg -y -f image2pipe -vcodec ppm -i - movie.mp4
