#!/bin/bash -ex

if [[ $# -ne 3 ]]
then
	echo "usage: $0 [seconds] [dec] [description]"
	echo "example: $0 60 10 exercise"
	exit 1
fi

sec=$1
dec=$2
desc=$3
while [[ $sec -gt 0 ]]
do
	espeak "there are $sec second to end of $desc"
	sleep "$dec"
	(( sec=sec-dec )) || true
done
espeak "the $desc is over!"
sleep 5
