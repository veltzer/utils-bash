#!/bin/bash -e

if [ $# -ne 1 ]
then
	echo "Error: This script requires a version"
	echo "Usage: $0 [version]"
	exit 1
fi

service="default"
version="$1"
gcloud app versions describe "${version}" --service "${service}"
