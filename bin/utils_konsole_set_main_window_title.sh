#!/bin/bash -e

# This will set the title of the current terminal window
#
# References:
# - https://askubuntu.com/questions/636944/how-to-change-the-title-of-the-current-terminal-tab-using-only-the-command-line

if [ $# -lt 1 ]
then
	echo "missing title."
	exit 1
fi

if [ $# -gt 1 ]
then
	echo "too many arugment. you only need title."
	exit 1
fi

# first lets find out what our session is
session=${TMUX##*,}
# now list all sessions and their ptys
pty="$(tmux list-clients -F '#{client_tty}' -t "$session")"
# now find out which applications are using that pty
pids=$(fuser "$pty" 2> /dev/null)
# find out which of them is 'konsole'
info=$(ps --no-headers -o comm,pid "$pids" | tr -s " " | grep "^konsole ")
# split the result and get the konsole pid
pid="${info##* }"
# set the title
qdbus "org.kde.konsole-$pid" /konsole/MainWindow_1 setWindowTitle "$1"
