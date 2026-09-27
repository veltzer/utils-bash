#!/bin/bash -eu

# Bump the minor version, commit, publish to crates.io, tag and push, all in
# one go (cargo-release does the work; see release.toml in the repo).
#
# The crates.io token lives in pass(1) only, under keys/crates.io, so there is
# no ~/.cargo/credentials file for cargo to fall back on. cargo-release runs
# "cargo publish" as a child process, which reads the token from
# CARGO_REGISTRY_TOKEN; hand it over through the environment of this one
# process, so it never lands on disk. The interactive cargo() wrapper from
# bash-bashy does the same thing, but a script does not see shell functions.

CARGO_REGISTRY_TOKEN="$(pass show keys/crates.io)" exec cargo release minor --execute --no-confirm
