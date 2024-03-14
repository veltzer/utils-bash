#!/bin/bash -e

for region in $(aws ec2 describe-regions --output text | cut -f4)
do
	echo "Listing Instances in region [${region}]"
	aws ec2 describe-instances --region "${region}"
done
