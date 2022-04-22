#!/bin/bash -e

# References:
# - https://stackoverflow.com/questions/30590083/how-do-i-rename-both-a-git-local-and-remote-branch-name

git branch -m master
git push origin master
# git push origin --delete main
# git push origin -u master
