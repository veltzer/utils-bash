#!/bin/bash -eu

# List all pads on a system
# This script does not work

for device_id in $(xinput list --id-only)
do
	# echo "${device_id}"
	device_name=$(xinput list --name-only "${device_id}")
	# Check if device has joystick/gamepad properties
	if xinput list-props "${device_id}" 2>/dev/null | grep -qi "joystick\|gamepad\|controller"
	then
		echo "ID: ${device_id} - ${device_name}"
	fi
done
