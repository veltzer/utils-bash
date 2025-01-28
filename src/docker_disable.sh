#!/bin/bash -e

# disable all docker related services
sudo systemctl disable docker.socket
sudo systemctl disable docker.service containerd.service docker.socket
