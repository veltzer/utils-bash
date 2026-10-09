#!/usr/bin/env python

"""
Install this repo into the user account using symlinks.

Everything lives under "src":
- standalone scripts go to ~/.local/bin
- python packages (directories) go to the python user site-packages
- perl modules (.pm files) go to ~/install/perl

Dead symlinks in the target folders that point back into this checkout are
removed first, so files deleted from the repo do not linger as dead links.
Links that are already correct are left untouched, so a rerun only reports
what actually changed.
"""

import argparse
import os
import os.path
import site
import sys


def unlink_stale(target_folder: str, source_folder: str, doit: bool, debug: bool) -> int:
    """remove dead links in target_folder which point back into source_folder"""
    removed = 0
    if not os.path.isdir(target_folder):
        return 0
    for filename in os.listdir(target_folder):
        full = os.path.join(target_folder, filename)
        if not os.path.islink(full):
            continue
        if not os.path.realpath(full).startswith(source_folder):
            continue
        if os.path.exists(full):
            continue
        if debug:
            print(f"unlinking [{full}]")
        if doit:
            os.unlink(full)
        removed += 1
    return removed


def do_install(source: str, target: str, doit: bool, debug: bool) -> str:
    """install a single symlink, replacing whatever link is already there"""
    replaced = False
    if os.path.islink(target):
        if os.readlink(target) == source:
            return "unchanged"
        if debug:
            print(f"unlinking [{target}]")
        if doit:
            os.unlink(target)
        replaced = True
    elif os.path.exists(target):
        print(f"not a symlink, leaving alone [{target}]", file=sys.stderr)
        return "skipped"

    if debug:
        print(f"symlinking [{source}] -> [{target}]")
    if doit:
        os.symlink(source, target)
    return "replaced" if replaced else "created"


def install(source_folder: str, target_folder: str, kind: str, doit: bool, debug: bool) -> dict:
    """symlink entries of source_folder into target_folder
    
    kind selects which entries to install:
    'python_packages' -> directories (ignoring __pycache__)
    'perl_modules' -> files ending in .pm
    'scripts' -> files not ending in .pm (and not __init__.py)
    """
    stats = {"removed_stale": 0, "created": 0, "replaced": 0, "unchanged": 0, "skipped": 0}
    source_folder = os.path.abspath(os.path.expanduser(source_folder))
    target_folder = os.path.abspath(os.path.expanduser(target_folder))
    
    if not os.path.isdir(source_folder):
        return stats  # Some repos won't have all types of source folders
        
    stats["removed_stale"] = unlink_stale(target_folder, source_folder, doit, debug)
    
    installed_any = False
    for entry in sorted(os.listdir(source_folder)):
        if entry in {"__init__.py", "__pycache__"}:
            continue
            
        source = os.path.join(source_folder, entry)
        is_dir = os.path.isdir(source)
        is_pm = entry.endswith(".pm")
        
        if kind == "python_packages":
            if not is_dir:
                continue
        elif kind == "perl_modules":
            if is_dir or not is_pm:
                continue
        elif kind == "scripts":
            if is_dir or is_pm:
                continue
        else:
            continue
            
        if not installed_any:
            if not os.path.isdir(target_folder):
                if debug:
                    print(f"mkdir [{target_folder}]")
                if doit:
                    os.makedirs(target_folder)
            installed_any = True
                
        res = do_install(source, os.path.join(target_folder, entry), doit, debug)
        stats[res] += 1
        
    return stats


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.strip().split("\n", maxsplit=1)[0])
    parser.add_argument(
        "--source_scripts", default="src", help="folder of scripts to install as commands (default: %(default)s)"
    )
    parser.add_argument(
        "--target_scripts", default="~/.local/bin", help="folder to install the commands into (default: %(default)s)"
    )
    parser.add_argument(
        "--source_packages", default="src", help="folder of python packages to install (default: %(default)s)"
    )
    parser.add_argument(
        "--target_packages", default=site.getusersitepackages(), help="folder to install python packages into (default: %(default)s)"
    )
    parser.add_argument(
        "--source_modules", default="src", help="folder of perl modules to install (default: %(default)s)"
    )
    parser.add_argument(
        "--target_modules", default="~/install/perl", help="folder to install perl modules into (default: %(default)s)"
    )
    parser.add_argument(
        "--dry_run", action="store_true", help="only show what would be done"
    )
    parser.add_argument(
        "--quiet", action="store_true", help="do not print what is being done"
    )
    
    args = parser.parse_args()
    doit = not args.dry_run
    debug = not args.quiet
    
    stats1 = install(args.source_scripts, args.target_scripts, "scripts", doit, debug)
    stats2 = install(args.source_packages, args.target_packages, "python_packages", doit, debug)
    stats3 = install(args.source_modules, args.target_modules, "perl_modules", doit, debug)
    
    total_stats = {k: stats1[k] + stats2[k] + stats3[k] for k in stats1}
    
    print("\n--- Installation Statistics ---")
    print(f"removed [{total_stats['removed_stale']}] stale symlinks")
    print(f"created [{total_stats['created']}] new symlinks")
    print(f"replaced [{total_stats['replaced']}] existing symlinks")
    print(f"left alone [{total_stats['unchanged']}] already correct symlinks")
    if total_stats["skipped"] > 0:
        print(f"skipped [{total_stats['skipped']}] paths that exist but are not symlinks")


if __name__ == "__main__":
    main()
