#!/bin/bash -eu

# Sync a repository's GitHub metadata (description and topics) from its local
# config/project.lua, printing only the fields that actually differ.
#
# Source of truth is config/project.lua in the repo:
#   NAME              -- the repository name (must match the GitHub repo)
#   DESCRIPTION_SHORT -- becomes the GitHub "description"
#   KEYWORDS          -- a lua list, becomes the GitHub "topics"
#
# For each of description and topics: if GitHub already matches the local
# value, nothing is printed and nothing is changed. If they differ, the
# difference is printed and GitHub is updated to match the local file. A repo
# whose local value is empty/absent is left alone (the file is the source of
# truth, and "unset locally" is not the same as "clear it on GitHub").
#
# Usage:
#   gh_sync_metadata.sh            # every repo the owner has (same as --all)
#   gh_sync_metadata.sh --all      # every repo the owner has, checked out
#                                  #   under the base dir
#   gh_sync_metadata.sh .          # just the repo in the current directory
#   gh_sync_metadata.sh DIR ...    # each named repo directory
#   DRY_RUN=1 gh_sync_metadata.sh  # print differences but change nothing
#
# --all lists the owner's repos with `gh repo list` and acts on each that has
# a checkout under the base dir (a repo with no local checkout is reported and
# skipped, since project.lua is the source of truth and lives in the checkout).
#
# Environment:
#   GH_OWNER     GitHub owner/user whose repos to sync   (default: veltzer)
#   GH_BASE_DIR  directory the repos are checked out under (default: ~/git)
#   DRY_RUN=1    print differences but make no changes
#
# Requires: gh (authenticated), jq, lua5.4.

OWNER="${GH_OWNER:-veltzer}"
DRY_RUN="${DRY_RUN:-0}"
BASE_DIR="${GH_BASE_DIR:-${HOME}/git}"

die() {
	echo "$1" >&2
	exit 1
}

command -v gh >/dev/null || die "gh is not installed"
command -v jq >/dev/null || die "jq is not installed"
LUA="$(command -v lua5.4 || command -v lua || true)"
[[ -n "${LUA}" ]] || die "lua is not installed"

# Read one scalar field (NAME or DESCRIPTION_SHORT) out of a project.lua.
# Prints the value, or nothing if the field is nil.
lua_scalar() {
	local file="$1" field="$2"
	"${LUA}" -e '
		local f, d = "'"${file}"'", "'"${field}"'"
		local ok = pcall(dofile, f)
		if not ok then os.exit(0) end
		local v = _G[d]
		if v ~= nil then io.write(tostring(v)) end
	'
}

# Read the KEYWORDS list out of a project.lua, one topic per line, sorted.
lua_keywords() {
	local file="$1"
	"${LUA}" -e '
		local f = "'"${file}"'"
		local ok = pcall(dofile, f)
		if not ok then os.exit(0) end
		if type(KEYWORDS) ~= "table" then os.exit(0) end
		table.sort(KEYWORDS)
		for _, k in ipairs(KEYWORDS) do print(k) end
	'
}

sync_one() {
	local dir="$1"
	local lua="${dir}/config/project.lua"

	if [[ ! -f "${lua}" ]]; then
		echo "${dir}: no config/project.lua, skipping" >&2
		return 0
	fi

	local name
	name="$(lua_scalar "${lua}" NAME)"
	[[ -n "${name}" ]] || { echo "${dir}: config/project.lua has no NAME, skipping" >&2; return 0; }

	local repo="${OWNER}/${name}"

	# --- description -----------------------------------------------------
	local want_desc have_desc
	want_desc="$(lua_scalar "${lua}" DESCRIPTION_SHORT)"
	if [[ -n "${want_desc}" ]]; then
		have_desc="$(gh repo view "${repo}" --json description --jq '.description // ""')"
		if [[ "${want_desc}" != "${have_desc}" ]]; then
			echo "${name}: description"
			echo "  local:  ${want_desc}"
			echo "  github: ${have_desc}"
			if [[ "${DRY_RUN}" == "0" ]]; then
				gh repo edit "${repo}" --description "${want_desc}" >/dev/null
			fi
		fi
	fi

	# --- topics ----------------------------------------------------------
	# Compare the two sets (order-independent). Only sync when the local
	# file actually declares keywords.
	local want_topics have_topics
	want_topics="$(lua_keywords "${lua}")"
	if [[ -n "${want_topics}" ]]; then
		have_topics="$(gh repo view "${repo}" --json repositoryTopics \
			--jq '[.repositoryTopics[].name] | sort | .[]')"
		if [[ "${want_topics}" != "${have_topics}" ]]; then
			echo "${name}: topics"
			echo "  local:  $(echo "${want_topics}" | paste -sd' ' -)"
			echo "  github: $(echo "${have_topics}" | paste -sd' ' -)"
			if [[ "${DRY_RUN}" == "0" ]]; then
				# Remove only topics that are NOT wanted, and add only those
				# not already present. A topic in both lists must be left
				# alone: gh applies --remove-topic and --add-topic in one
				# call and the remove wins, which would drop a shared topic.
				local args=()
				local t
				while IFS= read -r t; do
					[[ -n "${t}" ]] || continue
					grep -qxF "${t}" <<<"${want_topics}" || args+=(--remove-topic "${t}")
				done <<<"${have_topics}"
				while IFS= read -r t; do
					[[ -n "${t}" ]] || continue
					grep -qxF "${t}" <<<"${have_topics}" || args+=(--add-topic "${t}")
				done <<<"${want_topics}"
				[[ ${#args[@]} -gt 0 ]] && gh repo edit "${repo}" "${args[@]}" >/dev/null
			fi
		fi
	fi
}

# Act on every repo the owner has, resolving each to a checkout under BASE_DIR.
sync_all() {
	local name dir
	while IFS= read -r name; do
		[[ -n "${name}" ]] || continue
		dir="${BASE_DIR}/${name}"
		if [[ ! -d "${dir}" ]]; then
			echo "${name}: no checkout at ${dir}, skipping" >&2
			continue
		fi
		sync_one "${dir}"
	done < <(gh repo list "${OWNER}" --no-archived --source --limit 1000 \
		--json name --jq '.[].name')
}

# Default (no args) is --all: every repo the owner has.
if [[ $# -eq 0 || ( $# -eq 1 && "$1" == "--all" ) ]]; then
	sync_all
else
	for d in "$@"; do
		[[ "${d}" == "--all" ]] && { sync_all; continue; }
		sync_one "${d}"
	done
fi
