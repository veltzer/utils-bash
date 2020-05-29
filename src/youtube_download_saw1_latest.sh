utils_hibernate_disable.sh
# update youtube-dl
youtube-dl -U
youtube-dl\
	https://www.youtube.com/playlist?list=PLZHKR1yYunFR7sXhq3hA89NLRLoFcEwmR\
	--continue\
	--ignore-errors\
	--playlist-end 120
#	--playlist-start 15
utils_hibernate_enable.sh
