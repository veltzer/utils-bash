#!/bin/bash

# this is a small script to find bad symbolic links and printout their
# names.
# TODO: rewrite this script in python to be more extendble and possible
# a lot faster.
find . -type l -and -not -exec test -e {} \; -delete
