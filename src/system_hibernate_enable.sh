#!/bin/bash -eu

# Reference: https://www.tecmint.com/disable-suspend-and-hibernation-in-linux/
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
