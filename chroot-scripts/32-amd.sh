#!/bin/bash

clear
echo "##################################################"
echo "# installing amd graphics driver ...             #"
echo "##################################################"
sleep 3

XVBAVERSION="0.8.0-1"
CPU=`uname -m`
if [ "$CPU" = "i686" ]; then
   ARCH="i386"
else
   ARCH="amd64"
fi

(

if [ ! -f "/etc/apt/sources.list.d/ubuntu-x-swat-x-updates-precise.list" ]; then
	add-apt-repository -y ppa:ubuntu-x-swat/x-updates
fi
apt-get update
apt-get install --yes fglrx libva-dev libva1 libkms1 libdrm-dev vainfo
#apt-get install --yes fglrx-updates
cd /
wget http://www.splitted-desktop.com/~gbeauchesne/xvba-video/xvba-video_${XVBAVERSION}_${ARCH}.deb
dpkg -i xvba-video_${XVBAVERSION}_${ARCH}.deb
rm -f xvba-video_${XVBAVERSION}_${ARCH}.deb
cd /usr/lib/dri
ln -s /usr/lib/va/drivers/fglrx_drv_video.so fglrx_drv_video.so
cd /
echo LIBVA_DRIVER_NAME=xvba >> /etc/environment
echo LIBVA_DRIVERS_PATH=/usr/lib/va/drivers >> /etc/environment
#report installed packages
dpkg-query -W --showformat='${Package} ${Version}\n' > 18-amd-packages.txt

) 2>&1 | tee 32-amd.log
