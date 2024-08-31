#!/bin/bash -e
# Bash script to install VSCode extensions

while read -r extension; do
    code --force --install-extension "${extension}"
done < "${HOME}/.vscode-extensions.txt"
