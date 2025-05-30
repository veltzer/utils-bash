#!/bin/bash -eu

sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
sudo systemctl mask snapd.service
sudo systemctl mask snapd.socket
sudo systemctl mask snapd.seeded.service
sudo dpkg --purge snapd
