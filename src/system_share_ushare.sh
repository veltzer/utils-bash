#!/bin/bash -eu
# this is for ps3 (dlna)
#ushare --dlna -c . --daemon
ushare --daemon --interface eth1 --content .
