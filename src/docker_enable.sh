#!/bin/bash -eu

# enable all docker related services
sudo systemctl enable docker.socket docker.service containerd.service
