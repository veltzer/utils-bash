#!/bin/bash -e

# this script should be used when you are updating wordpress itself...

# shellcheck source=/dev/null
source ~/.myworld.sh

sudo chown -R www-data.www-data "${BLOGDIR}"
#sudo chmod 666 ${HTACCESS}
