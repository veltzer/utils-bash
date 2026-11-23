#!/bin/bash -eu

# List all pads on a system
# This script does not work

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for device_id in $(xinput list --id-only)
do
	# echo "${device_id}"
	device_name=$(xinput list --name-only "${device_id}")
	# Check if device has joystick/gamepad properties
	device_props=$(xinput list-props "${device_id}" 2>/dev/null || true)
	if grep -qi "joystick\|gamepad\|controller" <<< "${device_props}"
	then
		echo "ID: ${device_id} - ${device_name}"
	fi
done
