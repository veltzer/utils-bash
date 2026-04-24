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

# --- clean up old launchers ------------------------------------------

# Remove launchers we previously generated (matched by our prefix).
echo "removing old generated launchers..."
removed=0
for f in "${APPS_DIR}/${LAUNCHER_PREFIX}"*.desktop; do
    [[ -f "${f}" ]] || continue
    rm -v "${f}"
    removed=$((removed + 1))
done

# Also sweep any user-local launchers that point at google-chrome with a
# --profile-directory flag and weren't written by us — these are stale
# hand-rolled ones from past attempts. We do NOT touch system-wide
# launchers in /usr/share/applications/.
for f in "${APPS_DIR}"/*.desktop; do
    [[ -f "${f}" ]] || continue
    # skip files we're about to generate ourselves (already removed above)
    if grep -qE '^Exec=.*google-chrome.*--profile-directory=' "${f}" 2>/dev/null; then
        echo "removing stale per-profile launcher: ${f}"
        rm -f "${f}"
        removed=$((removed + 1))
    fi
done
echo "removed ${removed} launcher(s)."

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

echo
echo "generating launchers..."

count=0
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

    # Pretty comment: "Personal (mark.veltzer.personal@gmail.com)"
    if [[ -n "${email}" ]]; then
        comment="${name} (${email})"
    else
        comment="${name}"
    fi

    cat > "${out}" <<EOF
[Desktop Entry]
Version=1.0
Name=Chrome — ${name}
GenericName=Web Browser
Comment=${comment}
Exec=${CHROME_BIN} --profile-directory="${dir}" %U
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Actions=new-window;new-incognito-window;

[Desktop Action new-window]
Name=New Window
Exec=${CHROME_BIN} --profile-directory="${dir}" --new-window

[Desktop Action new-incognito-window]
Name=New Incognito Window
Exec=${CHROME_BIN} --profile-directory="${dir}" --incognito
EOF

    echo "  wrote ${out}  (${dir} → ${name})"
    count=$((count + 1))
done <<< "${profiles}"

# --- refresh desktop database ----------------------------------------

if command -v update-desktop-database >/dev/null 2>&1; then
    echo
    echo "refreshing desktop database..."
    update-desktop-database "${APPS_DIR}" 2>/dev/null || true
fi

echo
echo "done. generated ${count} launcher(s) in ${APPS_DIR}."
echo "they should appear in KRunner / Kickoff within a few seconds."
