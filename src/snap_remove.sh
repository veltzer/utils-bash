#!/bin/bash -eu

# remove all snap packages and snap itself

# snaps must be removed in the right order: apps first, then bases,
# then snapd last. bases and snapd are skipped on the first pass.
skip_re='^(core[0-9]*|bare|snapd)$'

while true
do
	remaining=$(snap list 2>/dev/null | awk 'NR>1 {print $1}' | grep -Ev "${skip_re}" || true)
	if [ -z "${remaining}" ]
	then
		break
	fi
	for x in ${remaining}
	do
		sudo snap remove --purge "${x}"
	done
done

# now remove the bases and snapd itself
for x in $(snap list 2>/dev/null | awk 'NR>1 {print $1}')
do
	sudo snap remove --purge "${x}"
done

# stop and purge snapd
sudo systemctl stop snapd.socket snapd.service 2>/dev/null || true
sudo apt-get purge -y snapd
sudo rm -rf /var/cache/snapd/ "${HOME}/snap"
