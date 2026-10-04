# TOFIX

Findings from a code scan on 2026-10-04.

## High

- `src/youtube_download_all.sh:2` - calls `utils_hibernate_disable.sh` / `utils_hibernate_enable.sh`, which no longer exist (the scripts are `src/system_hibernate_disable.sh` / `src/system_hibernate_enable.sh`); under `bash -eu` every youtube_download_* script dies on its first line. Same in `youtube_download_saw0.sh:2`, `youtube_download_saw0_latest.sh:2`, `youtube_download_saw1.sh:3`, `youtube_download_saw1_latest.sh:4`. Rename the calls.
- `src/system_sys_backup_system.sh:35` - `update-alternatives --get-selections` is redirected to `${TARGET_DPKG_SELECTIONS}`, overwriting the dpkg selections written on line 33, and `TARGET_ALTERNATIVES` (line 22) is never used; redirect to `${TARGET_ALTERNATIVES}`.
- `src/git_fsck.sh:8` - `cd "${x}"` runs outside the subshell and never returns, so only the first directory is checked and every later `[[ -d "${x}" ]]` is false (verified: with repos `a` and `b`, only `a` is fsck'd, exit 0). Move the `cd` into the `( ... )` like `git_gc_all.sh` does.
- `src/git_branches.sh:13` - `git config "branch.X.description"` exits 1 for a branch with no description, and under `#!/bin/bash -eu` that kills the script: in a repo with no descriptions it prints nothing and exits 1 (verified). Use `git config ... || true`.

## Medium

- `src/gdrive_sync_dry.sh:3` - the dry run previews `rclone sync . gdrive:` while the real `src/gdrive_sync.sh:3` runs `rclone sync encrypted gdrive:encrypted`; the dry run shows a different (and much more destructive) sync than the one it is meant to preview. Make it `rclone sync --dry-run encrypted gdrive:encrypted`.
- `src/pip_upgrade_all.sh:4` - `pip list --outdated --format=columns | cut -d " " -f 1` also emits the `Package` and `-------` header lines, so `pip install --upgrade Package` runs and fails, aborting the loop under `-e`; use `--format=freeze` / `--format=json` or skip the two header lines.
- `src/open_browser_remote.sh:3` - `python -m "import config.project; ..."` passes code to `-m` (which takes a module name) instead of `-c`, and `config/project.py` no longer exists in the fleet (it is `config/project.lua`); derive the name from the git remote or `config/project.lua`.
- `src/mysql_dump_all.sh:18` - passes the MySQL password on the command line (`-p"${PASS}"`, also line 25 and `src/mysql_alter_charset.sh:21`/`:25`), where it is visible in ps(1); since the local mark/root accounts use auth_socket the password is not needed at all - drop it (or feed it the way `src/mysql_login.sh` does).
- `src/mysql_login.sh:17` - fetches `passwords/mysql/${USER}` from pass(1) and forces it into the client config, but the local MySQL users (mark, root) authenticate via `auth_socket` (`mysql.user.plugin`), so the password is unused; the wrapper can be reduced to plain `mysql "$@"` (or removed) and the stale pass entries retired.
- `src/code_profile_extensions_install.sh:10` - tests the profile with `[ -f "${PROFILE}" ]`, but a VS Code profile is a directory, so the old profile is never removed and the "exists" branch is dead; use `-d`.
- `src/audio_go_realtime.sh:28` - `sudo stop mysql` is an Upstart command that no longer exists; under `-e` the script aborts there and never reaches the later steps. Use `systemctl stop mysql.service`.
- `src/audio_run_jack.sh:9` - `killall jackd` exits 1 when jack is not running, so under `-e` the script exits before it ever starts jack; use `killall jackd || true`. (`src/system_gnome_keyring.sh:4` has the same problem with `killall -9 gnome-keyring-daemon`.)
- `README.md:3` - the badge points at a workflow named `lint`, but the only workflow is `build` (`.github/workflows/build.yml:1`), so the badge is broken; point it at `workflows/build/badge.svg`.

## Low

- `src/git_recreate_symlinks.sh:28` - `ln -s "/home/mark/git/repos/${x}.git ${DIR}/${x}.git" .` quotes source and destination as one argument, the existence check on line 25 looks in the cwd instead of the repos dir, and `/home/mark/git/repos` no longer exists (also used by `src/git_clone_all.sh:3`); delete both scripts or fix the paths and quoting.
- `src/youtube_download_all.sh:3` - all youtube_download_* scripts use `youtube-dl`, which is unmaintained; switch to `yt-dlp` (already installed) and drop the `youtube-dl -U` self-update in `youtube_download_saw1_latest.sh:3`.
- `src/media_find.sh:3` - `-type f -name A -or -name B ...` without parentheses applies `-type f` only to the first pattern; wrap the `-name` alternatives in `\( ... \)`.
- `src/video_create_stats.sh:12` - `rm name_list_count.txt` fails on the first run (file absent) and aborts under `-e`; use `rm -f`.
- `src/wp_full_unlock.sh:8` - `chown user.group` is the deprecated separator (all wp_* scripts); use `root:root` / `www-data:www-data`.
- `src/devel_download_css_validator.sh:14` - downloads from `http://repo1.maven.org`, which has refused plain HTTP since 2020; use https (and `src/devel_build_css_validator.sh:19` checks out from a CVS server that no longer exists - delete it).
- `src/system_wifiup.sh:2` - the system_wifi*/system_wired* scripts drive `eth0`/`eth1` with `ifconfig`/`ifup`, which do not exist on current systems (predictable interface names, NetworkManager); delete them or port to `nmcli`.
- `doc/TODO.txt:13` - refers to `utils_hibernate_*` scripts; they are now `system_hibernate_*`.
