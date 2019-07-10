#!/bin/bash

source ~/.myworld.sh

sudo chown -R www-data.www-data ${BLOGDIR}{wp-admin,wp-content}
#sudo chmod 666 ${HTACCESS}
