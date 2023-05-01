#!/bin/bash -e

: <<'COMMENT'

This script creates sorted stats for a video folder by scanning
every folder 2 deep in and finding how many videos it has and
then sorting everything.

COMMENT

find by_name -mindepth 2 -maxdepth 2 -and -type d > name_list.txt
rm name_list_count.txt
while IFS= read -r line
do
	count=$(find "${line}" -type f | wc -l)
	echo "${line} ${count}" >> name_list_count.txt
done < name_list.txt
sort name_list_count.txt -r -n -k 2 > name_list_count_sorted.txt
