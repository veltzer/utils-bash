#!/bin/bash -eu
url=$(gh api repos/{owner}/{repo}/pages --jq '.html_url')
xdg-open "${url}"
