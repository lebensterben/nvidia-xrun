#!/usr/bin/env bash

# author
# Lucius Hu <https://github.com/lebensterben/nvidia-xrun>

# description
# This fork provides the benefits of nvidia-xrun without the extra dependency of bumblebee for power management. These utility scripts aim to make the life easier for nvidia cards users. It started with a revelation that bumblebee in current state offers very poor performance. This solution offers a bit more complicated procedure but offers a full GPU utilization.

# install
install -pDm 755 nvidia-xrun /usr/local/bin/nvidia-xrun
install -pDm 644 nvidia-xorg.conf /etc/X11/nvidia-xorg.conf
install -pDm 755 nvidia-xinitrc /etc/X11/xinit/nvidia-xinitrc
install -pDm 644 config/nvidia-xrun /etc/default/nvidia-xrun
install -pDm 644 nvidia-xrun-pm.service /etc/systemd/system/nvidia-xrun-pm.service

# files
# * The main program, which is a bash script
# - /usr/local/bin/nvidia-xrun
#
# * Configuration file for the program
# - /etc/default/nvidia-xrun
#
# * Configuration file for X11
# - /etc/X11/nvidia-xorg.conf
# - /etc/X11/xinit/nvidia-xinitrc
#
# * A systemd service file
# - /etc/systemd/system/nvidia-xrun-pm.service
