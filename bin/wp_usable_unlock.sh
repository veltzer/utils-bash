#!/bin/bash -e

# shellcheck source=/dev/null
source ~/.myworld.sh

sudo chown -R www-data.www-data "${BLOGDIR}"{wp-admin,wp-content}
#sudo chmod 666 ${HTACCESS}
