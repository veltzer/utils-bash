#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for region in $(aws ec2 describe-regions --output text | cut -f4)
do
	echo "Listing Instances in region [${region}]"
	aws ec2 describe-instances --region "${region}"
done
