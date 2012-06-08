#!/bin/bash

clear
echo "##################################################"
echo "# installing additional packages ...             #"
echo "##################################################"
sleep 3

(

#update repositories
apt-get update

#install additional software
apt-get install --yes ssh ethtool ntp nfs-kernel-server nfs-common samba smbfs smbclient linux-firmware-nonfree

#proftpd
mkdir /etc/proftpd
echo 'proftpd-basic shared/proftpd/inetd_or_standalone select from standalone' > /etc/proftpd/proftpd.seed
debconf-set-selections /etc/proftpd/proftpd.seed
apt-get install -y --force-yes -q proftpd
rm -f /etc/proftpd/proftpd.seed

#lirc
mkdir /etc/lirc
echo 'lirc lirc/remote select Windows Media Center Transceivers/Remotes (all)' > /etc/lirc/lirc_mce.seed
echo 'lirc lirc/transmitter select None' >> /etc/lirc/lirc_mce.seed
debconf-set-selections /etc/lirc/lirc_mce.seed
apt-get install -y --force-yes -q lirc
rm -f /etc/lirc/lirc_mce.seed

#lm-sensors
echo 'hddtemp hddtemp/daemon boolean false' > sensors.seed
debconf-set-selections sensors.seed
apt-get install -y --force-yes -q lm-sensors
rm -f sensors.seed

#sensors-detect script
rm -f /usr/sbin/sensors-detect
wget http://dl.lm-sensors.org/lm-sensors/files/sensors-detect -O /usr/sbin/sensors-detect
chmod +x /usr/sbin/sensors-detect

#report installed packages
dpkg-query -W --showformat='${Package} ${Version}\n' > 11-additional-packages.txt

) 2>&1 | tee 11-additionalpackages.log
