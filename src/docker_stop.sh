#!/bin/bash -e

docker network prune -f
sudo systemctl stop docker.service containerd.service
sudo ip link delete docker0
