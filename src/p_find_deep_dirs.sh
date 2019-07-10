#!/bin/bash

# find directories of depth 4 (there shouldnt be any)
find -L . -mindepth 4 -type d > err_deep.txt
