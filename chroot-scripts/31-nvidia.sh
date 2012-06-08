#!/bin/bash

clear
echo "##################################################"
echo "# installing nvidia graphics driver ...          #"
echo "##################################################"
sleep 3

(

if [ ! -f "/etc/apt/sources.list.d/ubuntu-x-swat-x-updates-precise.list" ]; then
	add-apt-repository -y ppa:ubuntu-x-swat/x-updates
fi
apt-get update
apt-get install --yes nvidia-current nvidia-settings libvdpau1
#apt-get install --yes nvidia-current-updates
#report installed packages
dpkg-query -W --showformat='${Package} ${Version}\n' > 17-nvidia-packages.txt

) 2>&1 | tee 31-nvidia.log
