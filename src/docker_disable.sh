#!/bin/bash -eu

# disable all docker related services
sudo systemctl disable docker.socket
sudo systemctl disable docker.service containerd.service
