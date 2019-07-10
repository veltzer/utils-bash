#!/bin/bash

<<'COMMENT'

This script runs earmaster for you

COMMENT

# this is to suspend pulseaudio (not really needed)
pasuspender -- wine /home/mark/.wine/drive_c/Program\ Files/EarMaster\ Pro\ 5/Ear50.exe 2> /dev/null &
# this is because timidity server is refusing to run on ubuntu so I just run it myself...
#killall timidity
#timidity -iA > /dev/null 2>&1 &

# to run the school 5 version
#wine "$HOME/.wine/drive_c/Program Files/EarMaster School 5/Ear50s.exe" 1> /dev/null 2> /dev/null &
# to run the pro 5 version
#wine "$HOME/.wine/drive_c/Program Files/EarMaster Pro 5/Ear50.exe" 1> /dev/null 2> /dev/null &
# to run the essential version
#wine "$HOME/.wine/drive_c/Program Files/EarMaster Essential 5/Ear50e.exe" 1> /dev/null 2> /dev/null &
# to run the pro 6 version
wine "$HOME/.wine/drive_c/Program Files/EarMaster Pro 6/Ear60.exe" 1> /dev/null 2> /dev/null &
