#!/bin/bash -e

if [ $# -ne 1 ]
then
	echo "Error: This script requires a version"
	echo "You can get it from: gcloud app versions list"
	echo "Usage: $0 [version]"
	exit 1
fi

# get the latest version deployed
# gcloud app version list --format=json | jq [...]

service="default"
version="$1"
gcloud app versions describe "${version}" --service "${service}" --format=json | jq -r ".deployment.files | keys[]"
