#!/bin/bash -eu

# Install the rs* tools from their GitHub releases into ~/install/binaries.
#
# These tools used to live in that folder as symlinks into
# ~/git/<repo>/target/release/<repo>. That coupling means a "clean" of a
# repository (cargo clean, a fresh checkout, a pruned target dir) breaks the
# command: the link survives but points at nothing. Installing the released
# binary instead makes each tool independent of the state of its checkout.
#
# Every rs* repo publishes the same release layout from the shared CI
# workflow: a tag "v<version>" carrying one asset per platform named
# "<repo>-<os>-<arch>". We fetch the asset for this machine.
#
# The install is incremental. A tool is downloaded only when it is missing or
# when the released version differs from the installed one, so a re-run on an
# up-to-date machine downloads nothing.
#
# The installed version is recorded in a ".<tool>_version" file next to the
# binary rather than read back out of the binary itself: not every tool
# accepts --version (rscontacts, rsslide and rsspell reject it outright), so
# asking the binary would silently re-download those on every run. The marker
# is written only after the binary is in place, so an interrupted install is
# never recorded as successful, and a missing marker simply reinstalls.

# where the binaries are installed...
DIR="${RS_INSTALL_DIR:-${HOME}/install/binaries}"

# the github account which owns the repositories...
OWNER="veltzer"

# the tools to install. each is both the repository name and the name of the
# resulting command, which is what the release assets are named after...
TOOLS="
rscalendar
rsconstruct
rscontacts
rsdedup
rsear
rsevo
rsimagetag
rslily
rsmarkdownlint
rsmermaid
rsmultigit
rspandoc
rspass
rspdfoverlay
rsshell
rssite
rsslide
rsspell
rssvglint
rstube
rstype
"

# gh does the release lookups and the downloads. it carries the
# authentication, so private repositories and the rate limit are handled for
# us, and it is already a hard dependency of the surrounding workflow...
if ! command -v gh > /dev/null
then
	echo "gh(1) is required but was not found, install it first" >&2
	exit 1
fi

# work out which release asset belongs to this machine. the suffixes are the
# ones the CI matrix produces...
case "$(uname -s)" in
	Linux) os="linux";;
	Darwin) os="macos";;
	*)
		echo "unsupported operating system [$(uname -s)]" >&2
		exit 1
		;;
esac
case "$(uname -m)" in
	x86_64|amd64) arch="x86_64";;
	aarch64|arm64) arch="aarch64";;
	*)
		echo "unsupported machine architecture [$(uname -m)]" >&2
		exit 1
		;;
esac
suffix="${os}-${arch}"

mkdir -p "${DIR}"

# downloads land here first and are moved into place only once complete, so
# an interrupted run never leaves a half-written binary behind...
tmpdir=$(mktemp -d)
# shellcheck disable=SC2064
# expand tmpdir now: it is what we want removed even if the variable changes
trap "rm -rf '${tmpdir}'" EXIT

installed=0
updated=0
current=0
missing=0

for tool in ${TOOLS}
do
	# the released version, taken from the tag ("v0.1.26" -> "0.1.26")...
	if ! tag=$(gh release view --repo "${OWNER}/${tool}" --json tagName --jq .tagName 2> /dev/null)
	then
		echo "${tool}: no release found, skipping" >&2
		missing=$((missing + 1))
		continue
	fi
	remote_version="${tag#v}"

	# the installed version, from the marker written by the last install. a
	# marker without its binary does not count as installed...
	target="${DIR}/${tool}"
	marker="${DIR}/.${tool}_version"
	local_version=""
	if test -x "${target}" && test -r "${marker}"
	then
		local_version=$(cat "${marker}")
	fi

	if test "${local_version}" = "${remote_version}"
	then
		echo "${tool}: ${local_version} is up to date"
		current=$((current + 1))
		continue
	fi

	asset="${tool}-${suffix}"
	echo "${tool}: installing ${remote_version}"
	if ! gh release download "${tag}" \
		--repo "${OWNER}/${tool}" \
		--pattern "${asset}" \
		--output "${tmpdir}/${tool}" \
		--clobber
	then
		echo "${tool}: could not download asset [${asset}] from [${tag}]" >&2
		exit 1
	fi
	chmod 755 "${tmpdir}/${tool}"

	# replace the old binary rather than writing over it: overwriting a file
	# which is currently executing fails with ETXTBSY, while a rename does
	# not disturb a running process at all...
	mv -f "${tmpdir}/${tool}" "${target}"
	echo "${remote_version}" > "${marker}"

	if test -z "${local_version}"
	then
		installed=$((installed + 1))
	else
		updated=$((updated + 1))
	fi
done

echo "${installed} installed, ${updated} updated, ${current} already current, ${missing} without a release"
