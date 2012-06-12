#!/bin/bash

#script based on:
#https://help.ubuntu.com/community/LiveCDCustomizationFromScratch

clear
echo "##################################################"
echo "# preparing the working environment ...          #"
echo "##################################################"
sleep 3

#set some variabels
export WORKDIR=$HOME/zbremaster/work
export CHROOTDIR=$WORKDIR/chroot
export LOGDIR=$WORKDIR/logs
export PKGDIR=$WORKDIR/packages
export UBVERSION=`lsb_release -c | awk -F: '{gsub(/[ \t]+/,"");print $2}'`
CPU=`uname -m`
if [ "$CPU" = "i686" ]; then
   export ARCH="i386"
else
   export ARCH="amd64"
fi

#create the working directories
if [ ! -d "$WORKDIR" ]; then
	mkdir -p $WORKDIR/{chroot,logs,packages}
fi

(

#define language to install
sudo rm $WORKDIR/lang*
if [ "$1" = "en" ]; then
	sudo touch $WORKDIR/lang.en
else
	sudo touch $WORKDIR/lang.de
fi

#installing needed packages
sudo apt-get install --yes debootstrap syslinux squashfs-tools genisoimage

#prepare chroot directory
if [ ! -d "$CHROOTDIR/home" ]; then
	sudo debootstrap --arch=$ARCH $UBVERSION $CHROOTDIR
fi

#mount /dev directory into chroot
sudo mount --bind /dev $CHROOTDIR/dev

#copy language selection file into chroot
sudo cp $WORKDIR/lang.* $CHROOTDIR/

#copy files for internet access inside chroot
sudo cp /etc/hosts $CHROOTDIR/etc/hosts
sudo cp /etc/resolv.conf $CHROOTDIR/etc/resolv.conf

#copy apt sources.list into chroot
sudo rm -f $CHROOTDIR/etc/apt/sources.list
sudo cp /etc/apt/sources.list $CHROOTDIR/etc/apt/sources.list

#copy chroot script into chroot
sudo cp 02-chroot.sh $CHROOTDIR/02-chroot.sh

#copy chroot modification scripts into chroot 
sudo cp chroot-scripts/*.sh $CHROOTDIR/

#make the scripts in chroot executable
sudo chmod +x $CHROOTDIR/*.sh

#copy other needed files into chroot
sudo mkdir -p $CHROOTDIR/zbremaster/{dvb,etc,media,plymouth,ubiquity-slideshow,vdr-1.7.23,xbmc,zbmenu,zbscripts}
sudo cp -r dvb/* $CHROOTDIR/zbremaster/dvb/
sudo cp -r etc/* $CHROOTDIR/zbremaster/etc/
sudo cp -r media/* $CHROOTDIR/zbremaster/media/
sudo cp -r plymouth/* $CHROOTDIR/zbremaster/plymouth/
sudo cp -r ubiquity-slideshow/* $CHROOTDIR/zbremaster/ubiquity-slideshow/
sudo cp -r vdr-1.7.23/* $CHROOTDIR/zbremaster/vdr-1.7.23/
sudo cp -r xbmc/* $CHROOTDIR/zbremaster/xbmc/
sudo cp -r zbmenu/* $CHROOTDIR/zbremaster/zbmenu/
sudo cp -r zbscripts/* $CHROOTDIR/zbremaster/zbscripts/

) 2>&1 | tee $LOGDIR/01-prepare.log

#jump into chroot
clear
echo "when in chroot run [./02-chroot.sh] ..."; sleep 5
sudo chroot $CHROOTDIR

### CHROOT ####################################################################
### -> 02-chroot.sh
### CHROOT ####################################################################

#set variabels
export WORKDIR=$HOME/zbremaster/work
export CHROOTDIR=$WORKDIR/chroot
export LOGDIR=$WORKDIR/logs
export PKGDIR=$WORKDIR/packages

#saving logfiles
sudo mv $CHROOTDIR/*.log $LOGDIR/

#saving package files
sudo mv $CHROOTDIR/*.txt $PKGDIR/

#cleanup chroot
sudo rm -f $CHROOTDIR/*.txt
sudo rm -f $CHROOTDIR/*.log
sudo rm -f $CHROOTDIR/*.sh
sudo umount -lf $CHROOTDIR/dev

clear
echo "now run [sudo ./03-create.sh] to create the ISO ..."
sleep 5
