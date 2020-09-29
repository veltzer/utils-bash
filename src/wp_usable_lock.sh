#!/bin/bash

# shellcheck source=/dev/null
source ~/.myworld.sh

sudo chown -R root.root "${BLOGDIR}"{wp-admin,wp-content}
#sudo chmod 644 ${HTACCESS}
