zbremaster
==========

Create ztreambox ISO from a remastered Ubuntu 12.04 with debootstrap (build from scratch).

ztreambox is a combination of software applications that allows you to use a Linux operating system as a media center pc. ztreambox is based on Ubuntu desktop system, the XBMC media center and a video disk recorder (VDR). For more informations look at www.ztreambox.com (english) or www.ztreambox.org (german).

Scripts are based on the description from https://help.ubuntu.com/community/LiveCDCustomizationFromScratch

How it works:

It`s the best to run the scripts in a VM, maybe in Virtual Box.
You need a preinstalled Ubuntu 12.04 Desktop Installation. First apply all updates.
Make a snapshot of the base installation so you can easily revert to a consistent state when something went wrong.

First install git-core:
sudo apt-get install git-core

Then clone the git repository:
git clone https://github.com/ztreambox/zbremaster.git

Change to directory zbremaster and run the prepare script:
cd zbremaster
sudo ./01-prepare.sh        <- this will make a german system !!!
sudo ./01-prepare.sh en     <- this will make a english system !!!

The script will make all the necessary preparations for our chroot environment and chroot into it.

When inside the chroot environment (root@computername:~$) run:
./02-chroot.sh

The script will run all the modification scripts copied from zbremaster/chroot-scripts.

When the scripts are ready type exit to leave the chroot system:
exit

Now run the last step by typing:
sudo ./03-create.sh

This last script will prepare the new filesystem.squahfs from the modified chroot system and will create an ISO file.

THIS IS BETA SOFTWARE !!!
All help welcome !

Yours
spocky184
