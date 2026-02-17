#!/bin/bash -eu

# claude_clean.sh — Remove all Claude Code sessions
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"

echo "Claude dir size: $(du -sh "${CLAUDE_DIR}" 2>/dev/null | cut -f1)"
echo "Cleaning all sessions..."

rm -rf "${CLAUDE_DIR}/projects"
echo "Cleaned project sessions"
rm -rf "${CLAUDE_DIR}/sessions"
echo "Cleaned sessions"
rm -rf "${CLAUDE_DIR}/tasks"
echo "Cleaned tasks"

echo "Done. Size now: $(du -sh "${CLAUDE_DIR}" 2>/dev/null | cut -f1)"
