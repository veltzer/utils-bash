#!/bin/bash -eu

# Print the Cloud Run address of the current repository's service, in the
# deterministic project-number form:
#
#   https://<service>-<project-number>.<region>.run.app
#
# gcloud_browse.sh prefers the custom domain when .gcp.conf has one; this
# script always prints the run.app address, which is the one to hand to
# scripts, health checks and OAuth/IAP configuration since it survives a
# domain change. The project-number form is the stable one Google documents;
# the older address with a random tag keeps working but is not printed here.
#
# Reads the repository's .gcp.conf (see gcloud_run_deploy.sh). Keys used:
#   gcp_configuration_name  gcloud configuration to activate (required)
#   gcp_service             Cloud Run service name (required)
#   gcp_region              region of the service (required)
#
# Usage: gcloud_browser_gcp_url.sh [path]
#   path   appended to the URL (e.g. app/version)

path="${1:-}"

if [[ ! -r .gcp.conf ]]
then
	echo "${0}: no .gcp.conf in $(pwd); run from the repository root" >&2
	exit 1
fi
# shellcheck source=/dev/null
source .gcp.conf
: "${gcp_configuration_name:?must be set in .gcp.conf}"
: "${gcp_service:?must be set in .gcp.conf}"
: "${gcp_region:?must be set in .gcp.conf}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name}"

project="$(gcloud config get-value project 2> /dev/null)"
number="$(gcloud projects describe "${project}" --format 'value(projectNumber)')"
url="https://${gcp_service}-${number}.${gcp_region}.run.app"
if [[ -n "${path}" ]]
then
	url="${url}/${path}"
fi
echo "${url}"
