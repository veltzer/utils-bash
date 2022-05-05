#!/bin/bash -e

# shellcheck source=/dev/null
source ~/.myworld.sh

sudo chown -R root.root "$BLOGDIR/wp-content/uploads"
