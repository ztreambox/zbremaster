#!/bin/bash

#script based on:
#https://help.ubuntu.com/community/LiveCDCustomizationFromScratch

clear
echo "##################################################"
echo "# creating the new ISO image ...                 #"
echo "##################################################"
sleep 3

#set variabels
export WORKDIR=$HOME/zbremaster/work
export CHROOTDIR=$WORKDIR/chroot
export IMAGEDIR=$WORKDIR/image
export LOGDIR=$WORKDIR/logs
export KERNEL="3.2.**-**-generic-pae"

(

#create the image directories
if [ -d "$IMAGEDIR" ]; then
	sudo rm -rf $IMAGEDIR
fi
mkdir -p $IMAGEDIR/{casper,isolinux,preseed}

#copy kernel
sudo cp $CHROOTDIR/boot/vmlinuz-$KERNEL $IMAGEDIR/casper/vmlinuz
sudo cp $CHROOTDIR/boot/initrd.img-$KERNEL $IMAGEDIR/casper/initrd.lz

#copy isolinux
cp /usr/lib/syslinux/isolinux.bin $IMAGEDIR/isolinux/
cp /usr/lib/syslinux/vesamenu.c32 $IMAGEDIR/isolinux/
if [ -f "$WORKDIR/lang.de" ]; then
	echo "de_DE.UTF-8" > $IMAGEDIR/isolinux/lang
	cp $WORKDIR/isolinux/isolinux-de.cfg $IMAGEDIR/isolinux/isolinux.cfg
else
	cp $WORKDIR/isolinux/isolinux-en.cfg $IMAGEDIR/isolinux/isolinux.cfg
fi
cp $WORKDIR/isolinux/splash.png $IMAGEDIR/isolinux/splash.png

#copy preseed
if [ -f "$WORKDIR/lang.de" ]; then
	cp $WORKDIR/preseed/chooseyourown-de.seed $IMAGEDIR/preseed/chooseyourown.seed
	cp $WORKDIR/preseed/allinone-de.seed $IMAGEDIR/preseed/allinone.seed
	cp $WORKDIR/preseed/seperatehome-de.seed $IMAGEDIR/preseed/seperatehome.seed
else
	cp $WORKDIR/preseed/chooseyourown-en.seed $IMAGEDIR/preseed/chooseyourown.seed
	cp $WORKDIR/preseed/allinone-en.seed $IMAGEDIR/preseed/allinone.seed
	cp $WORKDIR/preseed/seperatehome-en.seed $IMAGEDIR/preseed/seperatehome.seed
fi
cp $WORKDIR/preseed/ubuntu.seed $IMAGEDIR/preseed/ubuntu.seed

#create manifest
sudo chroot $CHROOTDIR dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee $IMAGEDIR/casper/filesystem.manifest
sudo cp -v $IMAGEDIR/casper/filesystem.manifest $IMAGEDIR/casper/filesystem.manifest-desktop
export REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-casper ubiquity-slideshow-ubuntu casper lupin-casper live-initramfs user-setup discover laptop-detect os-prober xresprobe libdebian-installer4'
for i in $REMOVE 
do
	sudo sed -i "/${i}/d" $IMAGEDIR/casper/filesystem.manifest-desktop
done

#compress chroot
sudo mksquashfs $CHROOTDIR $IMAGEDIR/casper/filesystem.squashfs
printf $(sudo du -sx --block-size=1 $CHROOTDIR | cut -f1) > $IMAGEDIR/casper/filesystem.size

#create diskdefines
cat << EOF | tee $IMAGEDIR/README.diskdefines
#define DISKNAME  Ubuntu 12.04 "Precise Pangolin" - Release i386 **ztreambox Remix**
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  i386
#define ARCHi386  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1
EOF

#create infos needed for usb creator
touch $IMAGEDIR/ubuntu
mkdir $IMAGEDIR/.disk
cd $IMAGEDIR/.disk
touch base_installable
echo "full_cd/single" > cd_type
echo 'Ubuntu 12.04 "ztreambox Remix" - i386' > info
echo "http//www.ztreambox.org" > release_notes_url

#calculate md5
cd $IMAGEDIR
sudo rm -f md5sum.txt
find . -type f -print0 | sudo xargs -0 md5sum | sudo sh -c 'grep -v "\./md5sum.txt" > md5sum.txt'

#create ISO image
export ISOLABEL="ztreambox"
if [ -f "$WORKDIR\lang.de" ]; then
	export ISONAME="ztreambox-12.04.01-remix-de-i386.iso"
else
	export ISONAME="ztreambox-12.04.01-remix-en-i386.iso"
fi
sudo mkisofs -r -V "$ISOLABEL" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../$ISONAME .
cd $WORKDIR
ls -l $WORKDIR/$ISONAME

) 2>&1 | tee $LOGDIR/03-create.log
