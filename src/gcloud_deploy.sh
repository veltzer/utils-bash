#!/bin/bash -e

# This app should be fixed. When deleting old versions there could be none, or more than one and this script
# does not handle that.

# --verbosity=info --version=1
gcloud app deploy --promote --stop-previous-version --quiet
# remove the old version that does not get any more traffic
version=$(gcloud app versions list --format=json | jq -r ".[] | select(.traffic_split == 0.0) | .id")
gcloud app versions delete "${version}" --quiet
