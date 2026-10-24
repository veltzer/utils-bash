#!/bin/bash -eu

# this script should be used when you are updating wordpress itself...

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# shellcheck source=/dev/null
source ~/.myworld.sh

sudo chown -R www-data.www-data "${BLOGDIR}"
#sudo chmod 666 ${HTACCESS}
