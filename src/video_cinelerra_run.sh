#!/bin/bash -eu

sudo sh -c "echo 0x7fffffff > /proc/sys/kernel/shmmax"
cinelerra &
