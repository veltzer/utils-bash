#!/bin/bash

source ~/.myworld.sh

find ${BLOGDIR} -not -user root -or -not -group root
