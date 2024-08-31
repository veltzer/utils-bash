#!/bin/bash -e
# Bash script to install VSCode extensions

while read extension; do
    code --install-extension "$extension"
done < "${HOME}/.vscode-extensions.txt"
