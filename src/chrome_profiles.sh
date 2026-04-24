#!/bin/bash -eu

for d in ~/.config/google-chrome/Default ~/.config/google-chrome/Profile\ 1 ~/.config/google-chrome/Profile\ 4; do
  name=$(jq -r '.profile.name // "?"' "${d}/Preferences" 2>/dev/null)
  email=$(jq -r '.account_info[0].email // "no account"' "${d}/Preferences" 2>/dev/null)
  echo "${d} → ${name} (${email})"
done
