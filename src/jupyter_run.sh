#!/bin/bash -e
nohup jupyter notebook &
echo $! > /tmp/jupyter_pid
