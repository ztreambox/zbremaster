#!/bin/bash

clear
echo "##################################################"
echo "# installing vdr ...                             #"
echo "##################################################"
sleep 3

export VDRDIR="vdr-1.7.23"
#export VDRDIR="vdr-1.7.27"
CPU=`uname -m`
if [ "$CPU" = "i686" ]; then
   export ARCH="i386"
else
   export ARCH="amd64"
fi

(

ISCONFED=`dpkg -s vdr | grep 'install ok installed'`
if [ -z "$ISCONFED" ]; then
	cd /
	#mkdir $VDRDIR
	cd zbremaster/$VDRDIR/$ARCH
	#download zip file
	#wget http://remaster.ztreambox.org/$VDRDIR/$ARCH/$VDRDIR.zip
	#unpack zip file
	unzip -o $VDRDIR.zip
	#install dependencies
	apt-get install -y --force-yes debhelper libcxxtools7 libtntnet9 sendemail w-scan libfontconfig1 libjpeg62 libpcrecpp0
	#install vdr and addons
	dpkg -i *.deb
	#cleanup
	cd /
	#rm -rf /$VDRDIR
	#report installed packages
	dpkg-query -W --showformat='${Package} ${Version}\n' > 13-vdr-packages.txt
fi

) 2>&1 | tee 21-vdr.log
