#!/bin/bash

clear
echo "##################################################"
echo "# configuring plymouth bootsplash ...            #"
echo "##################################################"
sleep 3

(

#plymouth ztreambox-logo
rm -rf /lib/plymouth/themes/ztreambox-logo
mkdir /lib/plymouth/themes/ztreambox-logo
wget http://remaster.ztreambox.org/plymouth/ztreambox_logo.png -O /lib/plymouth/themes/ztreambox-logo/ztreambox_logo.png
wget http://remaster.ztreambox.org/plymouth/ztreambox_logo16.png -O /lib/plymouth/themes/ztreambox-logo/ztreambox_logo16.png
wget http://remaster.ztreambox.org/plymouth/progress_dot_off.png -O /lib/plymouth/themes/ztreambox-logo/progress_dot_off.png
wget http://remaster.ztreambox.org/plymouth/progress_dot_off16.png -O /lib/plymouth/themes/ztreambox-logo/progress_dot_off16.png
wget http://remaster.ztreambox.org/plymouth/progress_dot_on.png -O /lib/plymouth/themes/ztreambox-logo/progress_dot_on.png
wget http://remaster.ztreambox.org/plymouth/progress_dot_on16.png -O /lib/plymouth/themes/ztreambox-logo/progress_dot_on16.png
wget http://remaster.ztreambox.org/plymouth/ztreambox-logo.script -O /lib/plymouth/themes/ztreambox-logo/ztreambox-logo.script
wget http://remaster.ztreambox.org/plymouth/ztreambox-logo.plymouth -O /lib/plymouth/themes/ztreambox-logo/ztreambox-logo.plymouth
update-alternatives --install /lib/plymouth/themes/default.plymouth default.plymouth /lib/plymouth/themes/ztreambox-logo/ztreambox-logo.plymouth 200
update-alternatives --auto default.plymouth

#modify ubuntu-text.plymouth
sed -i "s/title=Ubuntu 12.04/title=ztreambox 12.04.01/" /lib/plymouth/themes/ubuntu-text/ubuntu-text.plymouth
#change purple background to black background
sed -i "s/black=0x2c001e/black=0x000000/" /lib/plymouth/themes/ubuntu-text/ubuntu-text.plymouth
#change white text to zb-yellow text
sed -i "s/white=0xffffff/white=0xffbb09/" /lib/plymouth/themes/ubuntu-text/ubuntu-text.plymouth
#change red dots to zb-yellow dots
sed -i "s/brown=0xff4012/brown=0xffbb09/" /lib/plymouth/themes/ubuntu-text/ubuntu-text.plymouth
#change light purple text to white text
sed -i "s/blue=0x988592/blue=0xffffff/" /lib/plymouth/themes/ubuntu-text/ubuntu-text.plymouth

#let's make plymouth happy (XBMCbuntu Hook)
echo "blacklist radeon" > /etc/modprobe.d/blacklist-amd.conf
echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nvidia.conf
echo "blacklist lbm-nouveau" >> /etc/modprobe.d/blacklist-nvidia.conf
echo "blacklist nvidia-96" >> /etc/modprobe.d/blacklist-nvidia.conf
echo "blacklist nvidia-173" >> /etc/modprobe.d/blacklist-nvidia.conf
echo "alias nvidia nvidia-current" >> /etc/modprobe.d/blacklist-nvidia.conf
sed -i '/vesafb/d' /etc/modprobe.d/blacklist-framebuffer.conf
echo FRAMEBUFFER=y > /etc/initramfs-tools/conf.d/splash

) 2>&1 | tee 53-plymouth.log
