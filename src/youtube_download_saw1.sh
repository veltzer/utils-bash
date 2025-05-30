#!/bin/bash -eu

utils_hibernate_disable.sh
youtube-dl\
	https://www.youtube.com/playlist?list=PLZHKR1yYunFR7sXhq3hA89NLRLoFcEwmR\
	--continue\
	--ignore-errors
utils_hibernate_enable.sh
