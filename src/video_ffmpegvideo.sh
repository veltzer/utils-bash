#!/bin/bash

<<'COMMENT'

This script transcodes various video formats to MPEG2 Video and
AC3 audio in an MPEG2 Transport Stream for the DirecTV HR2x

FFMpeg and Mediainfo must be installed for this script to work.

Input Parameters: Input, Output, Video Bitrate, Audio Bitrate

Revision 2.00  11/29/2008
Updated to work with the HR2x auto screen size feature

COMMENT

VBITRATE="$3"
ABITRATE="$4"

width=`/usr/bin/mediainfo --Inform=Video\;%Width% "$1"`
height=`/usr/bin/mediainfo --Inform=Video\;%Height% "$1"`

audcodec="ac3"

aspect=$(echo "scale=2; ($width/$height)*100" | bc | awk -F '.' '{ print $1; exit; }' )

echo $aspect
comp=175
bars=0

if [ "$aspect" -gt "$comp" ]; then
   # needs bars top and bottom
   bars=1
   pad=$(echo "scale=2; (($width/1.75)-$height)/2" | bc | awk -F '.' '{ print $1; exit; }' )
   mod=$(($pad % 2))
   compmod=1
   if [ "$mod" -eq "$compmod" ]; then
      # pad must be an even number
      pad=$((pad+1))
   fi
fi

echo $pad

# Make sure the ffmpeg path is correct
if [ "$bars" -eq 1 ]; then
   # bars top and bottom
  exec ffmpeg -i "$1" -b ${VBITRATE} -maxrate ${VBITRATE} -minrate ${VBITRATE} \
-bufsize 5097k -bt 380k -padtop ${pad} -padbottom ${pad} -threads 2 -ab ${ABITRATE} \
-acodec ${audcodec} -async 1 -f mpegts -y - > "$2"
else
  # bars left and right
  exec ffmpeg -i "$1" -b ${VBITRATE} -maxrate ${VBITRATE} -minrate ${VBITRATE} \
-bufsize 5097k -bt 380k -padleft 4 -padright 4 -threads 2 -ab ${ABITRATE} \
-acodec ${audcodec} -async 1 -f mpegts -y - > "$2"
fi
