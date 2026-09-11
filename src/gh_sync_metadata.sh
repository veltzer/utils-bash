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
#   gh_sync_metadata.sh            # act on the repo in the current directory
#   gh_sync_metadata.sh DIR ...    # act on each named repo directory
#   DRY_RUN=1 gh_sync_metadata.sh  # print differences but change nothing
#
# Requires: gh (authenticated), jq, lua5.4.

OWNER="${GH_OWNER:-veltzer}"
DRY_RUN="${DRY_RUN:-0}"

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
				# --add-topic is additive; clear first so removed keywords
				# actually leave GitHub, then add the desired set.
				local args=()
				local t
				while IFS= read -r t; do
					[[ -n "${t}" ]] && args+=(--remove-topic "${t}")
				done <<<"${have_topics}"
				while IFS= read -r t; do
					[[ -n "${t}" ]] && args+=(--add-topic "${t}")
				done <<<"${want_topics}"
				gh repo edit "${repo}" "${args[@]}" >/dev/null
			fi
		fi
	fi
}

if [[ $# -eq 0 ]]; then
	sync_one "."
else
	for d in "$@"; do
		sync_one "${d}"
	done
fi
