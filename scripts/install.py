#!/usr/bin/env python

"""
Install this repo into the user account using symlinks.

The .sh files under "src" are standalone scripts. They become commands in
~/.local/bin as symlinks back into the git checkout, so editing a file here
changes the installed version immediately.

Symlinks in the target folder that point back into this checkout but no
longer match a script here are removed, so files deleted from the repo do not
linger as dead links.
"""

import argparse
import os
import os.path
import sys


def unlink_stale(target_folder: str, source_folder: str, keep: set[str], doit: bool, debug: bool) -> None:
    """remove links in target_folder which point back into source_folder

    keep holds the names we just installed, so only links left over from
    scripts which no longer exist in the repo are removed.
    """
    if not os.path.isdir(target_folder):
        return
    for filename in os.listdir(target_folder):
        if filename in keep:
            continue
        full = os.path.join(target_folder, filename)
        if not os.path.islink(full):
            continue
        if not os.readlink(full).startswith(source_folder):
            continue
        if debug:
            print(f"unlinking [{full}]")
        if doit:
            os.unlink(full)


def do_install(source: str, target: str, doit: bool, debug: bool) -> None:
    """install a single symlink, replacing whatever link is already there"""
    if os.path.islink(target):
        if os.readlink(target) == source:
            return
        if debug:
            print(f"unlinking [{target}]")
        if doit:
            os.unlink(target)
    if os.path.exists(target):
        print(f"not a symlink, leaving alone [{target}]", file=sys.stderr)
        return
    if debug:
        print(f"symlinking [{source}] -> [{target}]")
    if doit:
        os.symlink(source, target)


def install(source_folder: str, target_folder: str, doit: bool, debug: bool) -> None:
    """symlink the scripts of source_folder into target_folder"""
    source_folder = os.path.abspath(os.path.expanduser(source_folder))
    target_folder = os.path.abspath(os.path.expanduser(target_folder))
    if not os.path.isdir(source_folder):
        print(f"no such source folder [{source_folder}]", file=sys.stderr)
        sys.exit(1)
    if not os.path.isdir(target_folder):
        if debug:
            print(f"mkdir [{target_folder}]")
        if doit:
            os.makedirs(target_folder)
    installed = set()
    for entry in sorted(os.listdir(source_folder)):
        source = os.path.join(source_folder, entry)
        if not os.path.isfile(source):
            continue
        installed.add(entry)
        do_install(source, os.path.join(target_folder, entry), doit, debug)
    unlink_stale(target_folder, source_folder, installed, doit, debug)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.strip().split("\n", maxsplit=1)[0])
    parser.add_argument(
        "--source_scripts",
        default="src",
        help="folder of scripts to install as commands (default: %(default)s)",
    )
    parser.add_argument(
        "--target_scripts",
        default="~/.local/bin",
        help="folder to install the commands into (default: %(default)s)",
    )
    parser.add_argument(
        "--dry_run",
        action="store_true",
        help="only show what would be done",
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        help="do not print what is being done",
    )
    args = parser.parse_args()
    doit = not args.dry_run
    debug = not args.quiet
    install(args.source_scripts, args.target_scripts, doit, debug)


if __name__ == "__main__":
    main()
