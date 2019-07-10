#!/bin/bash
find -L . -maxdepth 3 -mindepth 3 -name "*not_here*" > err_not_here.txt
