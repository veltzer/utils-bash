#!/bin/bash -e

# Reference: https://www.tecmint.com/disable-suspend-and-hibernation-in-linux/
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
