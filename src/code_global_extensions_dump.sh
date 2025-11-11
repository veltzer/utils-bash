#!/bin/bash -eu

# This script will dump all current extensions install to your vscode to a local file
# called ".vscode-extensions.txt"

code --list-extensions > ".vscode-extensions.txt"
