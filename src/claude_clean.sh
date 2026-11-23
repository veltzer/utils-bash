#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# claude_clean.sh — Remove all Claude Code sessions
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"

size=$(du -sh "${CLAUDE_DIR}" 2>/dev/null || true)
echo "Claude dir size: ${size%%$'\t'*}"
echo "Cleaning all sessions..."

rm -rf "${CLAUDE_DIR}/projects"
echo "Cleaned project sessions"
rm -rf "${CLAUDE_DIR}/sessions"
echo "Cleaned sessions"
rm -rf "${CLAUDE_DIR}/tasks"
echo "Cleaned tasks"

size=$(du -sh "${CLAUDE_DIR}" 2>/dev/null || true)
echo "Done. Size now: ${size%%$'\t'*}"
