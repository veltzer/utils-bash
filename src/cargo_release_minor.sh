#!/bin/bash -eu

# Bump the minor version, commit, publish to crates.io, tag and push, all in
# one go (cargo-release does the work; see release.toml in the repo).
#
# cargo-release is a separate crate, not part of the toolchain, so a rebuilt
# CARGO_HOME loses it (bash-bashy's rust plugin reinstalls it, "cargo install
# cargo-release" does the same by hand). Check for it up front: cargo's own
# message for a missing subcommand, "no such command: release", does not say
# which crate is missing.
#
# The crates.io token lives in pass(1) only, under keys/crates.io, so there is
# no ~/.cargo/credentials file for cargo to fall back on. cargo-release runs
# "cargo publish" as a child process, which reads the token from
# CARGO_REGISTRY_TOKEN; hand it over through the environment of this one
# process, so it never lands on disk. The interactive cargo() wrapper from
# bash-bashy does the same thing, but a script does not see shell functions.

if ! command -v cargo-release > /dev/null
then
	echo "$(basename "$0"): cargo-release is not installed, run: cargo install cargo-release" >&2
	exit 1
fi

CARGO_REGISTRY_TOKEN="$(pass show keys/crates.io)" exec cargo release minor --execute --no-confirm
