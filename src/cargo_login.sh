#!/bin/bash -eu

# Make sure the crates.io setup is usable, without logging in.
#
# There is no login step any more: the crates.io token lives in pass(1) only,
# under keys/crates.io, and every command that needs it fetches it at run time
# into CARGO_REGISTRY_TOKEN for that one process (the bash-bashy cargo()
# wrapper for publish/owner/yank/release, cargo_release_*.sh for scripted
# releases). "cargo login" would copy the token into
# ${CARGO_HOME}/credentials.toml, a second place to leak from and to forget to
# rotate, so this script no longer runs it.
#
# What it does instead:
# - checks that the pass(1) entry exists and decrypts (which also unlocks the
#   gpg agent for the commands that follow)
# - removes any credentials file left over from the old "cargo login" way

pass show keys/crates.io > /dev/null
echo "crates.io token is available from pass(1) entry [keys/crates.io]"

cargo_home="${CARGO_HOME:-${HOME}/.cargo}"
for f in "${cargo_home}/credentials" "${cargo_home}/credentials.toml"; do
	if [ -e "${f}" ]; then
		rm -f "${f}"
		echo "removed stale on-disk token copy [${f}]"
	fi
done
