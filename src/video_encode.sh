#!/bin/bash

#mencoder -o "$HOME/$1.avi" -ovc lavc -oac mp3lame "$1"
mencoder -o "$HOME/links/mencoder/`date`.avi" -ovc copy -oac copy "$1"
