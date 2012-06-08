#!/bin/bash

clear
echo "##################################################"
echo "# configuring grub bootloader ...                #"
echo "##################################################"
sleep 3

(

#configure GRUB Bootloader
ISCONFED=`grep usbcore.autosuspend /etc/default/grub`
if [ -z "$ISCONFED" ]; then
	sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX=" usbcore.autosuspend=-1"/' /etc/default/grub
	sed -i 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE="1024x768"/' /etc/default/grub
	sed -i '26iGRUB_GFXPAYLOAD_LINUX="1024x768"' /etc/default/grub
	sed -i 's/#GRUB_DISABLE_RECOVERY/GRUB_DISABLE_RECOVERY/' /etc/default/grub
fi
#update the configuration
update-grub

) 2>&1 | tee 61-bootloader.log
