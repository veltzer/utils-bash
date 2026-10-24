#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# aws ec2 describe-instances --region "us-east-1"
aws ec2 describe-instances --region "eu-north-1" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text | tr "\t" "\n"
