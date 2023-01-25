#!/bin/bash -e

# run the docer services
docker network prune
sudo systemctl stop docker.service containerd.service
sudo ip link delete docker0
