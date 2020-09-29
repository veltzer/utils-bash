#!/bin/bash

# shellcheck source=/dev/null
source ~/.myworld.sh

find "${BLOGDIR}" -not -user root -or -not -group root
