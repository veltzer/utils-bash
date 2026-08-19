#!/bin/bash -e
# killall jupyter-notebook
kill -9 $(cat /tmp/jupyter_pid)
