#!/bin/bash -eu
utils_hibernate_disable.sh
youtube-dl\
	https://www.youtube.com/playlist?list=PLZHKR1yYunFQ3ciN2kHYg5y7YjKZUjMey\
	--continue\
	--ignore-errors\
	--playlist-end 20
utils_hibernate_enable.sh
