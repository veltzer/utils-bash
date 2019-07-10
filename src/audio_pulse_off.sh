#!/bin/bash

<<'COMMENT'

This script shuts down pulse audio so you can do recording sessions

COMMENT

echo "autospawn = no" > ~/.pulse/client.conf
pulseaudio --kill
