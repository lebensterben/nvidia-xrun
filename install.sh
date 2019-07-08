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
# * The main program, which is bash script
# - /usr/local/bin/nvidia-xrun
#
# * Configuration file for X11
# - /etc/X11/nvidia-xorg.conf
# - /etc/X11/xinit/nvidia-xinitrc
#
# * Configuration file for the program
# - /etc/default/nvidia-xrun
#
# * A systemd service file
# - /etc/systemd/system/nvidia-xrun-pm.service

# changelog
# * Sun Jul 7 2019 Lucius Hu <orctarorga@gmail.com>
# - `ModulePath` in `nvidia-xorg.conf` is changed to `/usr/lib64/xorg/modules` and `/opt/nvidia/lib64/xorg/modules`
# - `$LD_LIBRARY_PATH` in `nvidia-xinitrc` is changed to `/opt/nvidia/lib` and `/opt/nvidia/lib32`
# - Update to latest commit on `lebensterben/nvidia-xrun` fork (69afe21)
# 
# * Mon Jun 24 2019 Luke Short <ekultails@gmail.com> 0.3.0+79-1
# - Switch to using the standardized GitVersion guidelines for the RPM version
# - Update to the latest commit (af3b7349)
#
# * Sun May 05 2019 Luke Short <ekultails@gmail.com> 0.3.0_g755d612-1
# - Use commit hash for the source
# - Update to the latest commit
#
# * Thu Dec 28 2017 Abhiram Kuchibhotla <mailto:7677954+AxelSilverdew@users.noreply.github.com> 1
# - Initial RPM spec release
