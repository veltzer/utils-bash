#!/bin/bash -e

# aws ec2 describe-instances --region "us-east-1"
aws ec2 describe-instances --region "eu-north-1" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text | tr "\t" "\n"
