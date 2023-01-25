#!/bin/bash -e

# run the docer services
sudo systemctl stop docker.service containerd.service
sudo ip link delete docker0
