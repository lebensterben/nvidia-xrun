# nvidia-xrun
These utility scripts aim to make the life easier for nvidia cards users.
It started with a revelation that bumblebee in current state offers very poor performance. This solution offers a bit more complicated procedure but offers a full GPU utilization(in terms of linux drivers)

## Installation on Clear Linux

```sh
sudo ./install.sh
```

## Usage:
  1. switch to free tty
  2. login
  3. run `nvidia-xrun [app]`
  4. enjoy

Currently sudo is required as the script needs to wake up GPU, modprobe the nvidia driver and perform cleanup afterwards.

The systemd service can be used to completely remove the card from the kernel
device tree (so that it won't even show in `lspci` output), and this will
prevent the nvidia module to be loaded, so that we can take advantage of the
kernel PM features to keep the card switched off.

The service can be enabled with this command:

```sh
systemctl enable nvidia-xrun-pm
```

When the nvidia-xrun command is used, the device is added again to the tree so that the nvidia module can be loaded properly: nvidia-xrun will remove the device and enable PM again after the application terminates.

## Structure
**nvidia-xrun** - uses following dir structure:
* Executable script
  * **/usr/local/bin/nvidia-xrun** - the executable script
* Configuration file for **nvidia-xrun**
  * **/etc/default/nvidia-xrun** - nvidia-xrun config file
* System-wide configuration files for **X11**
  * **/etc/X11/nvidia-xorg.conf** - the main X confing file
  * **/etc/X11/nvidia-xorg.conf.d** - custom X config directory
  * **/etc/X11/xinit/nvidia-xinitrc** - xinitrc config file. Contains the setting of provider output source
  * **/etc/X11/xinit/nvidia-xinitrc.d** - custom xinitrc scripts directory
* **systemd** service file
  * **/etc/systemd/system/nvidia-xrun-pm.service** systemd service
* **xsession** files
  * **/usr/share/xsessions/nvidia-xrun-gnome.desktop** - xsession file for gnome
  * **/usr/share/xsessions/nvidia-xrun-xfce4.desktop** - xsession file for xfce4
  * **/usr/share/xsessions/nvidia-xrun-plasma.desktop** - xsession file for plasma
* [OPTIONAL] user-level custom xinit script file.
  * **$XDG_CONFIG_HOME/X11/nvidia-xinitrc** - You can put here your favourite window manager for example


## Setting the right bus id
Usually the 1:0:0 bus is correct. If this is not your case(you can find out through lspci or bbswitch output mesages) you can create
a conf script for example `nano /etc/X11/nvidia-xorg.conf.d/30-nvidia.conf` to set the proper bus id:

    Section "Device"
        Identifier "nvidia"
        Driver "nvidia"
        BusID "PCI:2:0:0"
    EndSection

You can use this command to get the bus id:

	lspci | grep -i nvidia | awk '{print $1}'

Also this way you can adjust some nvidia settings if you encounter issues:

    Section "Screen"
        Identifier "nvidia"
        Device "nvidia"
        #  Option "AllowEmptyInitialConfiguration" "Yes"
        #  Option "UseDisplayDevice" "none"
    EndSection

In order to make power management features work properly, you need to make sure
that bus ids in `/etc/default/nvidia-xrun` are correctly set for both the
NVIDIA graphic card and the PCI express controller that hosts it. You should be
able to find both the ids in the output of `lshw`: the PCIe controller is
usually displayed right before the graphic card.

## Automatically run window manager
For convenience you can create `nano ~/.nvidia-xinitrc` and put there your favourite window manager:

```sh
if [ $# -gt 0 ]; then
  $*
else
  gnome-session
  #xfce4-session
  #startkde
fi
```

With this you do not need to specify the app and you can simply run:

```sh
nvidia-xrun
```

## Troubleshooting
### Steam issues
Yes unfortunately running Steam directly with nvidia-xrun does not work well - I recommend to use some window manager like openbox.

### HiDPI issue
When using openbox on a HiDPI (i.e. 4k) display, everything could be so small that is difficult to read.
To fix, you can change the DPI settings in `~/.Xresources (~/.Xdefaults)` file by adding/changing `Xft.dpi` setting. For example :

```
Xft.dpi: 192
```

### `nouveau` driver conflict
`nouveau` driver should be automatically blacklisted by `nvidia` but in case it is not, `nvidia` might not get access to GPU. Then you need to manually blacklist `nouveau` following Arch wiki https://wiki.archlinux.org/index.php/kernel_modules#Blacklisting.

### avoid `nvidia` driver to load on boot
`nvidia` driver may load itself on boot, then `nvidia-xrun` will fail to start Xorg session.
To avoid that, you should blacklist it (see link above).
Also sometimes, blacklisting is not enough and you should use some hack to really avoid it to load.
For example, adding `install nvidia /bin/false` to `/etc/modprobe.d/nvidia.conf` will make every load to fail.
In that case, you should add `--ignore-install` to `modprobe` calls in `nvidia-xrun` script.

### Vulkan does not work
Check https://wiki.archlinux.org/index.php/Vulkan
* remove package vulkan-intel
* set VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
