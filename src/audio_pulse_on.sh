#!/bin/bash -eu

: <<'COMMENT'

This script turns pulse audio back on

COMMENT

rm -f ~/.pulse/client.conf
pulseaudio --start
