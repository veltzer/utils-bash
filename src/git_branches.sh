#!/bin/bash -eu

# the idea was taken from:
# https://github.com/bahmutov/git-branches/blob/master/branches.sh

function listBranchWithDescription() {
	branches=$(git branch --list "$1")
	while read -r branch
	do
		clean_branch_name=${branch//\*\ /}
		clean_branch_name=$(echo "${clean_branch_name}" | tr -d '[:cntrl:]' | sed -E "s/\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
		clean_branch_name=$(echo "${clean_branch_name}" | sed -E "s/^.+ -> //g")
		description=$(git config "branch.${clean_branch_name}.description")
		if [ "${branch::1}" == "*" ]; then
			printf "%s\n" "${branch} ${description}"
		else
			printf "  %s\n" "${branch} ${description}"
		fi
	done <<< "${branches}"
}

if [[ "$*" = "" ]]; then
	listBranchWithDescription "--color"
elif [[ "$*" =~ "--color" || "$*" =~ "--no-color" ]]; then
	listBranchWithDescription "$@"
else
	branch_operation_result=$(git branch "$@")
	printf "%s\n" "${branch_operation_result}"
fi
