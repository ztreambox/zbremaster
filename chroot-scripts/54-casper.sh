#!/bin/bash

clear
echo "##################################################"
echo "# modifying live cd settings ...                 #"
echo "##################################################"
sleep 3

(

#modify casper configuration
rm -f /etc/casper.conf
cat << EOF | tee /etc/casper.conf
USERNAME=xbmc
USERFULLNAME="ztreambox Live session user"
HOST=ztreambox
BUILD_SYSTEM=Custom
EOF

#set live cd language
if [ -f "lang.de" ]; then
	locale-gen de
	update-locale LANG=de_DE.UTF-8 LANGUAGE=de_DE.UTF-8 LC_ALL=de_DE.UTF-8
else
	locale-gen en
	update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
fi

#modify casper scripts
sed -i 's/USERNAME=casper/USERNAME=xbmc/' /usr/share/initramfs-tools/scripts/casper
sed -i 's/USERFULLNAME="Live session user"/USERFULLNAME="xbmc Live session user"/' /usr/share/initramfs-tools/scripts/casper
sed -i 's/HOST=live/HOST=ztreambox/' /usr/share/initramfs-tools/scripts/casper

#set default locale
if [ -f "lang.de" ]; then
	sed -i 's/locale=en_US.UTF-8/locale=de_DE.UTF-8/' /usr/share/initramfs-tools/scripts/casper-bottom/14locales
fi

) 2>&1 | tee 55-casper.log
