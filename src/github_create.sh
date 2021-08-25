#!/bin/bash -e

# References:
# - https://coderwall.com/p/mnwcog/create-new-github-repo-from-command-line

repo_name=$1
test -z "$repo_name" && echo "Repo name required." 1>&2 && exit 1

curl -u 'your_github_username' https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"
