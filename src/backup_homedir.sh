#!/bin/bash -e

# backup your home directory excluding folders which have a .NOBACKUP file in them

target="/tmp/homdir.tar.gz"

cd ~
tar --create --gzip --file "${target}" --exclude-tag-all=.NOBACKUP .
