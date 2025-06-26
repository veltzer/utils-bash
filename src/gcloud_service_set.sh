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

# --- Script Configuration ---
# Exit on any error, treat unset variables as an error, and prevent errors
# in a pipeline from being masked.
set -euo pipefail

# --- Constants ---
# The file containing the desired list of services.
readonly SERVICES_FILE=".services"

# --- Main Logic ---
main() {
  # 1. Input Validation
  if [[ ! -f "${SERVICES_FILE}" ]]
  then
    echo "Error: The required file '${SERVICES_FILE}' was not found in the current directory." >&2
    echo "Please create it with a list of services to enable, one per line." >&2
    exit 1
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
