#!/usr/bin/bash -eu
#
# rename-chrome-profiles.sh
#
# Renames Google Chrome profile directories under ~/.config/google-chrome/
# and updates Chrome's Local State so the profile dropdown still works.
#
# Usage (interactive):
#   ./rename-chrome-profiles.sh
#
# Usage (batch):
#   ./rename-chrome-profiles.sh "Profile 1=Teaching" "Profile 4=Personal"
#
# Flags: --dry-run, --no-backup, --help
# Requires: jq

set -euo pipefail

CHROME_CONFIG="${HOME}/.config/google-chrome"
LOCAL_STATE="${CHROME_CONFIG}/Local State"
BACKUP_DIR="${HOME}/.local/share/chrome-profile-backups"
DRY_RUN=0
DO_BACKUP=1

declare -a RENAME_PAIRS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            grep '^#' "$0" | head -20
            exit 0
            ;;
        --dry-run) DRY_RUN=1; shift ;;
        --no-backup) DO_BACKUP=0; shift ;;
        --*) echo "unknown flag: $1" >&2; exit 1 ;;
        *)
            [[ "$1" == *=* ]] || { echo "expected OLD=NEW, got: $1" >&2; exit 1; }
            RENAME_PAIRS+=("$1")
            shift
            ;;
    esac
done

command -v jq >/dev/null || { echo "install jq: sudo apt install jq" >&2; exit 1; }
[[ -d "${CHROME_CONFIG}" ]] || { echo "no ${CHROME_CONFIG}" >&2; exit 1; }
[[ -f "${LOCAL_STATE}" ]] || { echo "no ${LOCAL_STATE}" >&2; exit 1; }

if pgrep -x chrome >/dev/null || pgrep -x google-chrome >/dev/null; then
    echo "close Chrome first (pgrep -a chrome to see what's running)" >&2
    exit 1
fi

list_profiles() {
    jq -r '.profile.info_cache | to_entries[] |
           [.key, (.value.name // "?"), (.value.user_name // "no account")] | @tsv' \
        "${LOCAL_STATE}"
}

if [[ ${#RENAME_PAIRS[@]} -eq 0 ]]; then
    echo "current profiles:"
    echo
    printf "  %-20s  %-20s  %s\n" DIRECTORY "DISPLAY NAME" ACCOUNT
    printf "  %-20s  %-20s  %s\n" --------- ------------ -------
    while IFS=$'\t' read -r d n e; do
        printf "  %-20s  %-20s  %s\n" "$d" "$n" "$e"
    done < <(list_profiles)
    echo
    echo "enter renames as OLD=NEW, empty line to finish:"
    while true; do
        read -r -p "rename> " pair || break
        [[ -z "$pair" ]] && break
        [[ "$pair" == *=* ]] || { echo "  (need OLD=NEW)"; continue; }
        RENAME_PAIRS+=("$pair")
    done
fi

[[ ${#RENAME_PAIRS[@]} -eq 0 ]] && { echo "nothing to do"; exit 0; }

declare -a OLD_NAMES=() NEW_NAMES=()
for pair in "${RENAME_PAIRS[@]}"; do
    old="${pair%%=*}"
    new="${pair#*=}"
    [[ -z "$old" || -z "$new" ]] && { echo "bad pair: $pair" >&2; exit 1; }
    [[ "$old" == "Default" ]] && { echo "refusing to rename Default" >&2; exit 1; }
    [[ "$new" == "Default" ]] && { echo "refusing to rename to Default" >&2; exit 1; }
    [[ "$new" == *"/"* ]] && { echo "bad new name: $new" >&2; exit 1; }
    [[ -d "${CHROME_CONFIG}/${old}" ]] || { echo "no such profile dir: $old" >&2; exit 1; }
    [[ -e "${CHROME_CONFIG}/${new}" ]] && { echo "dest exists: $new" >&2; exit 1; }
    OLD_NAMES+=("$old")
    NEW_NAMES+=("$new")
done

echo
echo "plan:"
for i in "${!OLD_NAMES[@]}"; do
    echo "  '${OLD_NAMES[$i]}' -> '${NEW_NAMES[$i]}'"
done

if [[ $DRY_RUN -eq 1 ]]; then
    echo "--dry-run: no changes made"
    exit 0
fi

echo
read -r -p "proceed? [y/N] " c
[[ "$c" == "y" || "$c" == "Y" ]] || { echo "aborted"; exit 0; }

if [[ $DO_BACKUP -eq 1 ]]; then
    mkdir -p "$BACKUP_DIR"
    ts=$(date +%Y%m%d-%H%M%S)
    backup_file="${BACKUP_DIR}/chrome-config-${ts}.tar"
    echo "backing up to $backup_file..."
    tar -cf "$backup_file" -C "$HOME/.config" google-chrome
    echo "backup: $(du -h "$backup_file" | cut -f1)"
fi

echo "renaming directories..."
for i in "${!OLD_NAMES[@]}"; do
    mv -v "${CHROME_CONFIG}/${OLD_NAMES[$i]}" "${CHROME_CONFIG}/${NEW_NAMES[$i]}"
done

echo "rewriting Local State..."
mapping=$(
    for i in "${!OLD_NAMES[@]}"; do
        jq -n --arg o "${OLD_NAMES[$i]}" --arg n "${NEW_NAMES[$i]}" '{($o):$n}'
    done | jq -s 'add'
)

tmp=$(mktemp)
jq --argjson m "$mapping" '
    .profile.info_cache |= with_entries(
        if ($m | has(.key)) then .key = $m[.key] else . end)
  | .profile.last_used |= (
        if . != null and ($m | has(.)) then $m[.] else . end)
  | if (.profile.profiles_order // null) != null then
        .profile.profiles_order |= map(
            if ($m | has(.)) then $m[.] else . end)
    else . end
' "$LOCAL_STATE" > "$tmp"

if [[ ! -s "$tmp" ]] || ! jq empty "$tmp" 2>/dev/null; then
    echo "ERROR: jq produced invalid JSON. temp file at $tmp" >&2
    echo "directories already renamed - restore from $backup_file" >&2
    exit 1
fi
mv "$tmp" "$LOCAL_STATE"
echo "done."

echo
echo "result:"
while IFS=$'\t' read -r d n e; do
    m=" "; [[ -d "${CHROME_CONFIG}/${d}" ]] || m="!"
    printf "%s %-20s  %-20s  %s\n" "$m" "$d" "$n" "$e"
done < <(list_profiles)

echo
echo "next: test with"
for n in "${NEW_NAMES[@]}"; do
    echo "  google-chrome --profile-directory=\"$n\""
done
echo "then re-run regen-chrome-launchers.sh to update .desktop files"
[[ $DO_BACKUP -eq 1 ]] && echo "restore: tar -xf $backup_file -C $HOME/.config"
