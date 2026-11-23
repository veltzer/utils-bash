#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

regions_text=$(aws ec2 describe-regions --output text --query "Regions[].RegionName")
read -r -a regions <<< "${regions_text}"
for region in "${regions[@]}"
do
	echo "Listing Instances in region [${region}]"
	aws ec2 describe-instances --region "${region}"
done
