#!/bin/bash -eu

# Deploy the current repository to Cloud Run. Everything service-specific
# comes from the repository's .gcp.conf, so this script has no per-service
# knowledge and every repo deploys the same way. It replaces the App Engine
# gcloud_app_deploy.sh (no repo deploys to App Engine any more) and the
# earlier name of this script, gcloud_run_deploy.sh.
#
# .gcp.conf is bash-sourced. Keys used here:
#   gcp_configuration_name  gcloud configuration to activate (required)
#   gcp_service             Cloud Run service name (required)
#   gcp_region              region to deploy to (required)
#   gcp_run_args            bash array of extra `gcloud run deploy` flags:
#                           service account, env vars, secrets, Cloud SQL,
#                           scaling, --[no-]allow-unauthenticated, ...
#   gcp_job_name            optional: a Cloud Run Job deployed after the
#                           service, from the very image the service now
#                           runs (work the service starts in the background)
#   gcp_job_args            bash array of extra `gcloud run jobs deploy`
#                           flags for that job: its command, service account,
#                           env vars, secrets, Cloud SQL, timeout, retries
#
# Run from the repository root, where .gcp.conf lives. Cloud Build builds
# the Dockerfile and the new revision replaces the old one; Cloud Run keeps
# revision history itself, so unlike App Engine there is nothing to clean up.

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

if [[ ! -r .gcp.conf ]]
then
	echo "${0}: no .gcp.conf in $(pwd); run from the repository root" >&2
	exit 1
fi

# Only committed code is deployed: gcloud uploads the working tree, not a git
# revision, so a dirty tree would put code on the live site that is in no
# commit and cannot be reproduced or rolled back to. Untracked files count
# too (they are uploaded unless ignored); ignored ones, such as the
# build_info.json written below, do not.
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1
then
	echo "${0}: $(pwd) is not a git repository; only committed code is deployed" >&2
	exit 1
fi
if [[ -n "$(git status --porcelain)" ]]
then
	echo "${0}: the working tree has uncommitted changes; commit them first:" >&2
	git status --short >&2
	exit 1
fi

gcp_run_args=()
gcp_job_name=""
gcp_job_args=()
# shellcheck source=/dev/null
source .gcp.conf
: "${gcp_configuration_name:?must be set in .gcp.conf}"
: "${gcp_service:?must be set in .gcp.conf}"
: "${gcp_region:?must be set in .gcp.conf}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name}"

# Stamp what is about to be deployed so the app can serve it back (e.g. via
# an app/version endpoint). The Cloud Run revision name is not known before
# the deploy; apps read it at runtime from the K_REVISION env var instead.
jq -n \
	--arg deploy_date "$(date --utc --iso-8601=seconds)" \
	--arg git_describe "$(git describe --always --dirty --tags)" \
	'{deploy_date: $deploy_date, git_describe: $git_describe}' > build_info.json

gcloud run deploy "${gcp_service}" \
	--source . \
	--region "${gcp_region}" \
	--quiet \
	"${gcp_run_args[@]}"

if [[ -z "${gcp_job_name}" ]]
then
	exit 0
fi
# The job runs the same code as the service: the image the new revision
# runs, by digest, so a later build cannot slip in between.
image="$(gcloud run services describe "${gcp_service}" --region "${gcp_region}" --format 'value(spec.template.spec.containers[0].image)')"
if [[ -z "${image}" ]]
then
	echo "${0}: could not find the image of service ${gcp_service}" >&2
	exit 1
fi
exec gcloud run jobs deploy "${gcp_job_name}" \
	--image "${image}" \
	--region "${gcp_region}" \
	--quiet \
	"${gcp_job_args[@]}"
