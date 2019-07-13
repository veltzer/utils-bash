# make this script more complicated: make it download the data
# one by one and stop when he sees he already downloaded something.
# turn it input python maybe?

utils_hibernate_disable.sh
# update youtube-dl
youtube-dl -U
youtube-dl\
	https://www.youtube.com/playlist?list=PLZHKR1yYunFQ3ciN2kHYg5y7YjKZUjMey\
	--continue\
	--ignore-errors\
	--playlist-end 120
#	--playlist-start 15
utils_hibernate_enable.sh
