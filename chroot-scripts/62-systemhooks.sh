#!/bin/bash

clear
echo "##################################################"
echo "# configuring system settings ...                #"
echo "##################################################"
sleep 3

(

#disable login messages
if [ ! -f "/etc/skel/.hushlogin" ]; then
	touch /etc/skel/.hushlogin
fi

#deactivate tty2-6
ISCONFED=`grep "tty\[1-6\]" /etc/default/console-setup`
if [ ! -z "$ISCONFED" ]; then
	sed -i 's/tty\[1-6\]/tty1/' /etc/default/console-setup
	rm -f /etc/init/tty2.conf
	rm -f /etc/init/tty3.conf
	rm -f /etc/init/tty4.conf
	rm -f /etc/init/tty5.conf
	rm -f /etc/init/tty6.conf
fi

#disable cd-rom lock
ISCONFED=`grep dev.cdrom.lock /etc/sysctl.conf`
if [ -z "$ISCONFED" ]; then
	echo "dev.cdrom.lock=0" >> /etc/sysctl.conf
fi

#disable floppy
ISCONFED=`grep floppy /etc/modprobe.d/blacklist.conf`
if [ -z "$ISCONFED" ]; then
	echo "" >> /etc/modprobe.d/blacklist.conf
	echo "# Boot speed optimization" >> /etc/modprobe.d/blacklist.conf
	echo "blacklist floppy" >> /etc/modprobe.d/blacklist.conf
fi

#deactivate periodical updates
if [ -f /etc/apt/apt.conf.d/10periodic ]; then
   sed -i 's/APT::Periodic::Update-Package-Lists \"1\";/APT::Periodic::Update-Package-Lists \"0\";/g' /etc/apt/apt.conf.d/10periodic
fi

#deactivate message of the day
if [ -f /etc/update-motd.d/91-release-upgrade ]; then
   rm /etc/update-motd.d/91-release-upgrade
fi

#modify distribution description
if [ -f /etc/lsb-release ]; then
    sed -i -e "/^DISTRIB_DESCRIPTION/s/\"\(.*\)\"/\"\ztreambox - based on Ubuntu Precise\"/" /etc/lsb-release
fi

#deactivate ipv6 (http://wiki.ubuntuusers.de/Tuning)
ISCONFED=`grep net.ipv6.conf.all.disable_ipv6=1 /etc/sysctl.conf`
if [ -z "$ISCONFED" ]; then
	echo " " >> /etc/sysctl.conf
	echo "#systemwide deactivation of IPv6 - by ztreambox" >> /etc/sysctl.conf
	echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
fi

#Disable ureadahead
if [ -f /etc/init/ureadahead.conf ]; then
   mv /etc/init/ureadahead.conf /etc/init/ureadahead.conf.disabled
fi

#rc.local NEW (XBMCbuntu 12-setupWakeFromUSB.sh)
sudo rm -f /etc/rc.local
cat << EOF | sudo tee /etc/rc.local
#!/bin/sh
# -e removed
# rc.local modified by ztreambox
#
# Enable wakeup for USB
DEVICES=\$(dmesg | grep input: | grep usb | grep -vi mouse| awk -F/ '{ print \$4}')
for device in \$DEVICES
	do
		usbPort=\$(cat /proc/acpi/wakeup | grep \$device | awk '{ print \$1}')
		usbStatus=\$(cat /proc/acpi/wakeup | grep \$usbPort | awk {'print \$3}')
		if [ "\$usbStatus" = "*disabled" -o "\$usbStatus" = "disabled" ]; then
			echo \$usbPort > /proc/acpi/wakeup
	fi
done

#Enable WOL on eth0
sleep 5
ethtool -s eth0 wol g

exit 0
EOF
sudo chmod +x /etc/rc.local

#lirc-resume
rm -f /etc/pm/sleep.d/99lirc-resume
cat << EOF | tee /etc/pm/sleep.d/99lirc-resume
#!/bin/bash

# This script will restart Lirc upon resume.

. /usr/lib/pm-utils/functions

case "\$1" in
        hibernate|suspend)
                /etc/init.d/lirc stop
                echo "Unloading lirc kernel modules"
                rmmod ir-lirc-codec
                rmmod lirc_dev
                ;;
        thaw|resume)
                echo "Loading lirc kernel modules"
                modprobe ir-lirc-codec
                modprobe lirc_dev
                /etc/init.d/lirc start
                ;;
        *)
                ;;

esac

exit \$?
EOF
chmod +x /etc/pm/sleep.d/99lirc-resume

) 2>&1 | tee 62-systemhooks.log
