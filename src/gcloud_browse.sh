#!/bin/bash -eu

# Open the live deployment of the current repository in the web browser.
#
# Reads the repository's .gcp.conf (see gcloud_run_deploy.sh): a repo with
# gcp_domain is served on that custom domain, one with gcp_service/gcp_region
# is a Cloud Run service on its run.app address, anything else is assumed
# to be an App Engine app. Prints the URL and opens it.
#
# Usage: gcloud_browse.sh [-n] [path]
#   -n     print the URL only, do not launch a browser
#   path   appended to the URL (e.g. app/version)
#
# For Cloud Run the deterministic URL form is used
# (https://<service>-<project-number>.<region>.run.app) rather than the
# older one with a random tag, since that is the form registered with
# OAuth clients, IAP and the like.

launch=1
if [[ "${1:-}" == "-n" ]]
then
	launch=0
	shift
fi
path="${1:-}"

if [[ ! -r .gcp.conf ]]
then
	echo "${0}: no .gcp.conf in $(pwd); run from the repository root" >&2
	exit 1
fi
# shellcheck source=/dev/null
source .gcp.conf
: "${gcp_configuration_name:?must be set in .gcp.conf}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name}"

if [[ -n "${gcp_domain:-}" ]]
then
	url="https://${gcp_domain}"
elif [[ -n "${gcp_service:-}" ]]
then
	: "${gcp_region:?must be set in .gcp.conf}"
	project="$(gcloud config get-value project 2> /dev/null)"
	number="$(gcloud projects describe "${project}" --format 'value(projectNumber)')"
	url="https://${gcp_service}-${number}.${gcp_region}.run.app"
else
	url="$(gcloud app browse --no-launch-browser 2> /dev/null)"
fi
if [[ -n "${path}" ]]
then
	url="${url}/${path}"
fi

echo "${url}"
if [[ "${launch}" == 1 ]]
then
	xdg-open "${url}"
fi
