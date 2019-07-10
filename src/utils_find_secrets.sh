#!/bin/bash

# this is a simple script to find my secret folders
find . -type d -and -not -perm 775
