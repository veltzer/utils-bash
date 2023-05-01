#!/bin/bash

# remove all snap packages and snap itself

snaps_list=$(snap list | tail -n +2 | tr -s " " | cut -f 1 -d " ")
for x in ${snaps_list}
do
	sudo snap remove "${x}"
done
