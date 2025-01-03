#!/bin/bash -e

# Deploy the new version first
gcloud app deploy --promote --stop-previous-version --quiet

# Get a list of all versions and their traffic splits
versions=$(gcloud app versions list --format=json)

# Extract the IDs of versions with 0 traffic split
inactive_versions=$(echo "${versions}" | jq -r ".[] | select(.traffic_split==0.0) | .id")

# If there are any inactive versions, delete them
if [[ -n "${inactive_versions}" ]]
then
	# Iterate over each inactive version and delete it
	while IFS= read -r version
	do
		echo "Deleting inactive version: ${version}"
		gcloud app versions delete "${version}" --quiet
	done <<< "${inactive_versions}"
else
	echo "No inactive versions found."
fi
