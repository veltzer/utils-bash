#!/bin/bash -e

# shellcheck source=/dev/null
source ~/.myworld.sh

sudo chown -R www-data.www-data "${BLOGDIR}/wp-content/uploads"
