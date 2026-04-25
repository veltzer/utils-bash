#!/usr/bin/bash -eu

#
# regen-chrome-launchers.sh
#
# Reads Google Chrome profiles from Local State and generates one
# .desktop launcher per profile in ~/.local/share/applications/.
# Removes any previously-generated Chrome per-profile launchers first.
#
# Requires: jq
#
# Usage: ./regen-chrome-launchers.sh

set -euo pipefail

CHROME_CONFIG="${HOME}/.config/google-chrome"
LOCAL_STATE="${CHROME_CONFIG}/Local State"
APPS_DIR="${HOME}/.local/share/applications"
LAUNCHER_PREFIX="chrome-profile-"   # our generated files share this prefix
CHROME_BIN="/usr/bin/google-chrome-stable"

# --- sanity checks ---------------------------------------------------

if ! command -v jq >/dev/null 2>&1; then
    echo "error: jq is not installed. install it with: sudo apt install jq" >&2
    exit 1
fi

if [[ ! -f "${LOCAL_STATE}" ]]; then
    echo "error: ${LOCAL_STATE} not found" >&2
    echo "is Google Chrome installed and has it been run at least once?" >&2
    exit 1
fi

if [[ ! -x "${CHROME_BIN}" ]]; then
    echo "warning: ${CHROME_BIN} not found or not executable" >&2
    echo "the launchers will still be written but may not work until Chrome is installed" >&2
fi

mkdir -p "${APPS_DIR}"

# --- enumerate stale launchers (defer deletion until after we know what we'd write) ---

# Collect launchers we previously generated (matched by our prefix).
declare -a stale_ours=()
for f in "${APPS_DIR}/${LAUNCHER_PREFIX}"*.desktop; do
    [[ -f "${f}" ]] || continue
    stale_ours+=("${f}")
done

# Also collect user-local launchers that point at google-chrome with a
# --profile-directory flag and weren't written by us — stale hand-rolled ones.
# We do NOT touch system-wide launchers in /usr/share/applications/.
declare -a stale_other=()
for f in "${APPS_DIR}"/*.desktop; do
    [[ -f "${f}" ]] || continue
    # skip our own prefix — already covered above
    case "$(basename "${f}")" in
        "${LAUNCHER_PREFIX}"*) continue ;;
    esac
    if grep -qE '^Exec=.*google-chrome.*--profile-directory=' "${f}" 2>/dev/null; then
        stale_other+=("${f}")
    fi
done

# --- enumerate profiles and generate launchers -----------------------

# jq emits one TSV line per profile: "<dir>\t<name>\t<email>"
# Using NUL separator would be cleaner but TSV is fine since profile
# directory names and display names don't contain tabs in practice.
profiles=$(jq -r '
  .profile.info_cache
  | to_entries[]
  | [.key, (.value.name // "Unnamed"), (.value.user_name // "")]
  | @tsv
' "${LOCAL_STATE}")

if [[ -z "${profiles}" ]]; then
    echo "no profiles found in ${LOCAL_STATE}" >&2
    exit 1
fi

# Build desired launcher content for each profile, and only write files whose
# on-disk content differs. Track which of our existing files are still wanted
# so we don't delete-then-rewrite identical files.

declare -A wanted_paths=()
wrote=0
unchanged=0

while IFS=$'\t' read -r dir name email; do
    # Sanitize the display name for use in a filename:
    # lowercase, spaces -> hyphens, strip anything that isn't [a-z0-9-].
    slug=$(echo "${name}" \
        | tr '[:upper:]' '[:lower:]' \
        | tr ' ' '-' \
        | tr -cd 'a-z0-9-')
    # Fallback if the name slugs to nothing (e.g. non-ASCII-only name).
    [[ -z "${slug}" ]] && slug=$(echo "${dir}" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

    out="${APPS_DIR}/${LAUNCHER_PREFIX}${slug}.desktop"
    wanted_paths["${out}"]=1

    wmclass="chrome-${slug}"

    # Pretty comment: "Personal (mark.veltzer.personal@gmail.com)"
    if [[ -n "${email}" ]]; then
        comment="${name} (${email})"
    else
        comment="${name}"
    fi

    desired=$(cat <<EOF
[Desktop Entry]
Version=1.0
Name=Chrome — ${name}
GenericName=Web Browser
Comment=${comment}
Exec=${CHROME_BIN} --profile-directory="${dir}" --class="${wmclass}" %U
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=${wmclass}
Actions=new-window;new-incognito-window;

[Desktop Action new-window]
Name=New Window
Exec=${CHROME_BIN} --profile-directory="${dir}" --new-window

[Desktop Action new-incognito-window]
Name=New Incognito Window
Exec=${CHROME_BIN} --profile-directory="${dir}" --incognito
EOF
)

    if [[ -f "${out}" ]] && [[ "$(cat "${out}")" == "${desired}" ]]; then
        echo "  unchanged ${out}  (${dir} → ${name})"
        unchanged=$((unchanged + 1))
    else
        printf '%s\n' "${desired}" > "${out}"
        echo "  wrote ${out}  (${dir} → ${name})"
        wrote=$((wrote + 1))
    fi
done <<< "${profiles}"

# --- remove stale launchers that we are no longer generating ---------

removed=0
for f in "${stale_ours[@]}"; do
    # Keep it if we just wrote / confirmed it above.
    [[ -n "${wanted_paths[${f}]:-}" ]] && continue
    rm -v "${f}"
    removed=$((removed + 1))
done
for f in "${stale_other[@]}"; do
    echo "removing stale per-profile launcher: ${f}"
    rm -f "${f}"
    removed=$((removed + 1))
done

# --- refresh desktop database (only if something actually changed) ---

if (( wrote > 0 || removed > 0 )); then
    if command -v update-desktop-database >/dev/null 2>&1; then
        echo
        echo "refreshing desktop database..."
        update-desktop-database "${APPS_DIR}" 2>/dev/null || true
    fi
    echo
    echo "done. wrote ${wrote}, unchanged ${unchanged}, removed ${removed} launcher(s) in ${APPS_DIR}."
    echo "they should appear in KRunner / Kickoff within a few seconds."
else
    echo
    echo "no changes were needed — ${unchanged} launcher(s) already up to date in ${APPS_DIR}."
fi
