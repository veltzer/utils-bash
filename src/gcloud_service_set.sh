#!/bin/bash -eu
#
# gcloud_service_set.sh
#
# Synchronizes the enabled services in the current GCP project to match a
# predefined list in a file named .services.
#
# This script will:
# 1. Enable services listed in .services that are not currently enabled.
# 2. Disable services that are enabled but NOT listed in .services.
# 3. Prompt for confirmation before making any destructive changes.
#
# With --check nothing is changed: the differences are printed and the
# exit status is 1 when the project does not match .services, so a repo
# can use it to spot drift.
#
# When run from a repository root with a .gcp.conf, its gcloud
# configuration is activated first (see gcloud_run_deploy.sh).
#

# --- Script Configuration ---
# Exit on any error, treat unset variables as an error, and prevent errors
# in a pipeline from being masked.
set -euo pipefail
# comm needs both lists sorted the same way it compares them.
export LC_ALL=C

# --- Constants ---
# The file containing the desired list of services.
readonly SERVICES_FILE=".services"

# --- Main Logic ---
main() {
  local check=0
  if [[ "${1:-}" == "--check" ]]
  then
    check=1
  fi

  # 1. Input Validation
  if [[ ! -f "${SERVICES_FILE}" ]]
  then
    echo "Error: The required file '${SERVICES_FILE}' was not found in the current directory." >&2
    echo "Please create it with a list of services to enable, one per line." >&2
    exit 1
  fi
  if [[ -r .gcp.conf ]]
  then
    # shellcheck source=/dev/null
    source .gcp.conf
    export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name:?must be set in .gcp.conf}"
  fi

  local project_id
  project_id=$(gcloud config get-value project)
  echo "Targeting project: ${project_id}"
  echo "-------------------------------------"

  # 2. Get Desired and Current State
  # Read from the file, remove comments and empty lines, and sort uniquely.
  local desired_services
  desired_services=$(grep -v -e '^#' -e '^$' "${SERVICES_FILE}" | sort -u)

  # Get currently enabled services from gcloud.
  echo "Fetching currently enabled services..." >&2
  local enabled_services
  enabled_services=$(gcloud services list --enabled --format="value(config.name)" | sort -u)

  # 3. Calculate Differences
  # Use 'comm' to find the difference between the two sorted lists.
  local services_to_enable
  services_to_enable=$(comm -23 <(echo "${desired_services}") <(echo "${enabled_services}"))

  local services_to_disable
  services_to_disable=$(comm -13 <(echo "${desired_services}") <(echo "${enabled_services}"))

  if [[ "${check}" == 1 ]]
  then
    if [[ -z "${services_to_enable}" && -z "${services_to_disable}" ]]
    then
      echo "Project [${project_id}] matches ${SERVICES_FILE}."
      exit 0
    fi
    [[ -n "${services_to_enable}" ]] && printf 'Listed but not enabled:\n%s\n' "${services_to_enable}"
    [[ -n "${services_to_disable}" ]] && printf 'Enabled but not listed:\n%s\n' "${services_to_disable}"
    exit 1
  fi

  # 4. Enable Services
  if [[ -n "${services_to_enable}" ]]
  then
    echo -e "\nThe following services will be ENABLED:"
    echo "${services_to_enable}"
    echo
    echo "${services_to_enable}" | xargs -n 1 gcloud services enable
    echo "-------------------------------------"
  else
    echo -e "\nAll desired services are already enabled."
  fi

  # 5. Disable Services
  if [[ -n "${services_to_disable}" ]]
  then
    echo -e "\nThe following services will be DISABLED:"
    echo "${services_to_disable}"
    
    # Require explicit confirmation from the user.
    read -p "Are you absolutely sure you want to disable these services? (yes/no) " -r
    if [[ "${REPLY}" != "yes" ]]
    then
      echo "Aborting disable operation."
      exit 0
    fi
    
    echo "${services_to_disable}" | xargs -n 1 gcloud services disable --force
  else
    echo "No services to disable."
  fi

  echo -e "Synchronization complete for project [${project_id}]."
}

# Run the main function
main "$@"
