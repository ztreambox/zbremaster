#!/bin/bash

#script based on:
#https://help.ubuntu.com/community/LiveCDCustomizationFromScratch

clear
echo "##################################################"
echo "# customizing the chroot system ...              #"
echo "##################################################"
sleep 3

#prepare chroot
mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C
apt-get update
apt-get install --yes dbus
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

###############################################################################
### start modification area ###################################################
###############################################################################

#execute chroot modification scripts
for script in $(find -type f - perm /u=x,g=x,o=x | sort)
do
	$script || true
done

clear
echo "##################################################"
echo "# updating initramfs ...                         #"
echo "##################################################"
#update the initramfs
update-initramfs -u

clear
echo "##################################################"
echo "# upgrade system if needed ...                   #"
echo "##################################################"
#upgrade system if needed
apt-get --yes upgrade

###############################################################################
### end modification area #####################################################
###############################################################################

#hack to install without /pool and /dists folder on cd
sed -i "s/self.configure_apt/#self.configure_apt/" /usr/share/ubiquity/plugininstall.py

clear
echo "##################################################"
echo "# cleanup chroot ...                             #"
echo "##################################################"
sleep 3

#cleanup chroot
apt-get clean
rm -f /var/lib/dbus/machine-id
rm -f /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl
rm -rf /tmp/*

rm -rf /boot/*.bak
rm -rf ~/.bash_history
rm -rf /var/lib/dpkg/*-old
rm -rf /var/lib/aptitude/*.old
rm -rf /var/cache/debconf/*.dat-old
rm -rf /var/log/*.gz

rm -f /etc/resolv.conf
rm -f /etc/hosts
umount -lf /proc
umount -lf /sys
umount -lf /dev/pts

clear
echo "now type [exit] to leave chroot and continue ..."; sleep 5
