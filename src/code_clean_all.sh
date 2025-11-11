#!/bin/bash -eu

# This script will remove all vscode extensions

code --list-extensions | xargs -n 1 code --uninstall-extension
