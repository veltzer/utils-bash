#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# shellcheck source=/dev/null
source ~/.myworld.sh

sudo chown -R root.root "${BLOGDIR}"{wp-admin,wp-content}
#sudo chmod 644 ${HTACCESS}
