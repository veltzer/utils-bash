#!/bin/bash -eu

# Remove old Claude Code binaries left behind by the self-updater.
#
# The native installer keeps every version it ever downloaded under
#   ~/.local/share/claude/versions/<version>
# and points ~/.local/bin/claude at the current one. Each binary is ~200MB
# and nothing ever removes the old ones, so the directory grows with every
# update. This script deletes every version except the one in use.
#
# Which version is "in use" is decided by resolving the claude symlink
# (~/.local/bin/claude, or whatever `claude` on PATH resolves to). The newest
# version by version-sort is always kept too, so a broken or missing symlink
# can never lead to deleting everything.
#
# Only entries whose name looks like a version (e.g. 2.1.270) are considered;
# anything else in the directory (partial downloads, lock files) is left alone.
#
# Usage:
#   claude_remove_old_versions.sh            # delete old versions
#   DRY_RUN=1 claude_remove_old_versions.sh  # only print what would be deleted
#
# Environment:
#   CLAUDE_VERSIONS_DIR  where the versions live
#                        (default: ~/.local/share/claude/versions)
#   DRY_RUN=1            print what would be removed but remove nothing

VERSIONS_DIR="${CLAUDE_VERSIONS_DIR:-${HOME}/.local/share/claude/versions}"
DRY_RUN="${DRY_RUN:-0}"

die() {
	echo "$1" >&2
	exit 1
}

[[ -d "${VERSIONS_DIR}" ]] || die "no versions directory at ${VERSIONS_DIR}"

# Collect the installed versions (names only), newest last.
mapfile -t versions < <(
	find "${VERSIONS_DIR}" -mindepth 1 -maxdepth 1 -printf '%f\n' |
	grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' |
	sort -V
)
[[ ${#versions[@]} -gt 0 ]] || die "no versions found under ${VERSIONS_DIR}"

# The versions to keep: whatever the symlinks resolve to, plus the newest.
declare -A keep=()
for link in "${HOME}/.local/bin/claude" "$(command -v claude || true)"; do
	[[ -n "${link}" && -e "${link}" ]] || continue
	target="$(readlink -f "${link}")"
	[[ "$(dirname "${target}")" == "$(readlink -f "${VERSIONS_DIR}")" ]] || continue
	keep["$(basename "${target}")"]=1
done
keep["${versions[-1]}"]=1

echo "keeping: ${!keep[*]}"

removed=0
for version in "${versions[@]}"; do
	[[ -n "${keep[${version}]:-}" ]] && continue
	path="${VERSIONS_DIR}/${version}"
	size="$(du -sh "${path}" | cut -f1)"
	if [[ "${DRY_RUN}" == "1" ]]; then
		echo "would remove: ${version} (${size})"
	else
		echo "removing: ${version} (${size})"
		rm -rf "${path}"
	fi
	removed=$((removed + 1))
done

if [[ ${removed} -eq 0 ]]; then
	echo "nothing to remove"
elif [[ "${DRY_RUN}" != "1" ]]; then
	echo "total size now: $(du -sh "${VERSIONS_DIR}" | cut -f1)"
fi
