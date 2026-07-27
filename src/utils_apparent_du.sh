#!/bin/bash
# apparent-du - recursive listing plus total apparent size of a folder.
#
# Unlike du(1), which reports allocated blocks, this sums the apparent
# size (st_size) of every regular file found, so sparse files and files
# smaller than a block count for what they claim to be.

set -uo pipefail

usage() {
	cat <<'EOF'
usage: apparent-du [-q] [-a] [DIR...]

	-q  quiet: print only the totals, skip the per-file listing
	-a  include non-regular files (symlinks, fifos, sockets) in the listing
	    and in the size total; by default only regular files are summed

With no DIR, the current directory is used. Hidden files are included.
Symlinks are never followed; their own size is counted only with -a.
EOF
}

quiet=0
all_types=0

while getopts ':qah' opt; do
	case "${opt}" in
	q) quiet=1 ;;
	a) all_types=1 ;;
	h)
		usage
		exit 0
		;;
	\?)
		printf 'apparent-du: invalid option -- %s\n\n' "${OPTARG}" >&2
		usage >&2
		exit 2
		;;
	esac
done
shift $((OPTIND - 1))

if [ "$#" -eq 0 ]; then
	set -- .
fi

# Render a byte count as a human-readable string, binary units.
human() {
	local bytes=${1}
	if [ "${bytes}" -lt 1024 ]; then
		printf '%d B' "${bytes}"
		return
	fi
	local units=(KiB MiB GiB TiB PiB)
	local i=0 scaled=${bytes}
	# Keep two extra decimal digits of precision through the divisions.
	local value=$((bytes * 100))
	while [ "${scaled}" -ge 1048576 ] && [ "${i}" -lt 4 ]; do
		value=$((value / 1024))
		scaled=$((scaled / 1024))
		i=$((i + 1))
	done
	value=$((value / 1024))
	printf '%d.%02d %s' $((value / 100)) $((value % 100)) "${units[${i}]}"
}

status=0

for dir in "$@"; do
	if [ ! -d "${dir}" ]; then
		printf 'apparent-du: %s: not a directory\n' "${dir}" >&2
		status=1
		continue
	fi

	if [ "${all_types}" -eq 1 ]; then
		find_expr=(! -type d)
	else
		find_expr=(-type f)
	fi

	# NUL-delimited so that newlines in filenames stay intact.
	total=0
	count=0
	while IFS= read -r -d '' line; do
		size=${line%%	*}
		path=${line#*	}
		total=$((total + size))
		count=$((count + 1))
		if [ "${quiet}" -eq 0 ]; then
			printf '%12d  %s\n' "${size}" "${path}"
		fi
	done < <(find "${dir}" "${find_expr[@]}" -printf '%s\t%p\0' 2>/dev/null)

	dirs=$(find "${dir}" -type d -printf 'x\n' 2>/dev/null | wc -l)

	if [ "${quiet}" -eq 0 ] && [ "${count}" -gt 0 ]; then
		echo
	fi
	printf '%s: %s apparent in %d files, %d directories\n' \
		"${dir}" "$(human "${total}")" "${count}" "${dirs}"
	printf '  exact: %d bytes\n' "${total}"
done

exit "${status}"
