#!/usr/bin/env bash
#
# mute-chrome-notifications.sh
#
# Suppresses Google Chrome notifications at the Plasma (KDE) notification-
# daemon level. This stops Plasma from displaying any notification whose
# origin is Chrome — including Chrome's own update/download notifications
# AND website push notifications that Chrome forwards to the system tray.
#
# This does NOT touch Chrome's internal Preferences file (which governs
# per-site permission grants). To stop websites from asking in the first
# place, do that in the UI:
#     chrome://settings/content/notifications
#
# Reversible: run with --undo to restore.
#
# Tested on KDE Plasma 6 (kwriteconfig6). Falls back to kwriteconfig5.
#
# Usage:
#   ./mute-chrome-notifications.sh          # mute
#   ./mute-chrome-notifications.sh --undo   # unmute

set -euo pipefail

# Pick the right kwriteconfig for Plasma 6 vs 5
if command -v kwriteconfig6 >/dev/null 2>&1; then
    KW="kwriteconfig6"
elif command -v kwriteconfig5 >/dev/null 2>&1; then
    KW="kwriteconfig5"
else
    echo "error: neither kwriteconfig6 nor kwriteconfig5 found" >&2
    echo "this script requires KDE Plasma" >&2
    exit 1
fi

# Plasma identifies notification sources by "desktop entry" name, which
# corresponds to the basename of the .desktop file (without extension).
# Chrome installs as google-chrome.desktop, so the entry is "google-chrome".
#
# We also cover the variants just in case (user-installed, Chromium, etc.).
CHROME_ENTRIES=(
    "google-chrome"
    "google-chrome-stable"
    "chromium"
    "chromium-browser"
)

# Action: mute vs undo
MODE="mute"
if [[ "${1:-}" == "--undo" ]]; then
    MODE="undo"
fi

# Plasma stores per-app notification settings in ~/.config/plasmanotifyrc
# under sections like [Applications][$entry]. The key "Seen=true" registers
# the app as known to the notification system; "ShowPopups=false" disables
# the toast popup; "ShowInHistory=false" hides it from the history.
#
# Reference: plasma-workspace source, ApplicationSettingsPlugin.

CONFIG_FILE="plasmanotifyrc"

# Pick the matching kreadconfig for value comparisons (idempotency check).
if command -v kreadconfig6 >/dev/null 2>&1; then
    KR="kreadconfig6"
elif command -v kreadconfig5 >/dev/null 2>&1; then
    KR="kreadconfig5"
else
    KR=""
fi

# Number of keys that actually required a write across all entries.
changes=0

set_key() {
    # Write a key only if its current value differs from the desired one.
    local group="$1" key="$2" desired="$3"
    if [[ -n "${KR}" ]]; then
        local current
        current=$(${KR} --file "${CONFIG_FILE}" --group "${group}" --key "${key}" 2>/dev/null || true)
        if [[ "${current}" == "${desired}" ]]; then
            return 0
        fi
    fi
    ${KW} --file "${CONFIG_FILE}" --group "${group}" --key "${key}" "${desired}"
    changes=$((changes + 1))
}

apply() {
    local entry="$1"
    local group="Applications/${entry}"
    local before="${changes}"

    if [[ "${MODE}" == "mute" ]]; then
        set_key "${group}" "Seen" "true"
        set_key "${group}" "ShowPopups" "false"
        set_key "${group}" "ShowPopupsInDoNotDisturbMode" "false"
        set_key "${group}" "ShowInHistory" "false"
        set_key "${group}" "ShowBadges" "false"
    else
        set_key "${group}" "ShowPopups" "true"
        set_key "${group}" "ShowPopupsInDoNotDisturbMode" "false"
        set_key "${group}" "ShowInHistory" "true"
        set_key "${group}" "ShowBadges" "true"
    fi

    if (( changes > before )); then
        if [[ "${MODE}" == "mute" ]]; then
            echo "  muted: ${entry}"
        else
            echo "  unmuted: ${entry}"
        fi
    else
        echo "  unchanged: ${entry}"
    fi
}

echo "${MODE}ing Chrome notifications in Plasma..."
for entry in "${CHROME_ENTRIES[@]}"; do
    apply "${entry}"
done

if (( changes == 0 )); then
    echo
    echo "no changes were needed — settings already in the desired state."
    exit 0
fi

# Reload the notification server so changes take effect immediately.
# We try a couple of ways — busctl is most reliable on Plasma 6.
echo
echo "reloading notification service..."
if command -v busctl >/dev/null 2>&1; then
    busctl --user call org.kde.plasmashell /PlasmaShell \
        org.kde.PlasmaShell refreshCurrentShell 2>/dev/null || true
fi

if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.kded6 /kded reconfigure 2>/dev/null || true
elif command -v qdbus >/dev/null 2>&1; then
    qdbus org.kde.kded5 /kded reconfigure 2>/dev/null || true
fi

echo
if [[ "${MODE}" == "mute" ]]; then
    cat <<'EOF'
done.

Chrome notifications are now suppressed at the Plasma level.

To also stop websites from *asking* to send notifications, open Chrome and go to:
  chrome://settings/content/notifications
Set "Sites can ask to send notifications" to off, and review the
"Allowed to send notifications" list to revoke any existing grants.

To reverse this script:
  ./mute-chrome-notifications.sh --undo
EOF
else
    echo "done. Chrome notifications are re-enabled in Plasma."
fi
