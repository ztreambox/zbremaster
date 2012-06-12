#!/bin/bash

clear
echo "##################################################"
echo "# configuring init scripts ...                   #"
echo "##################################################"
sleep 3

(

#copy init scripts
rm -f /etc/init/ztreambox*.conf
#wget http://remaster.ztreambox.org/etc/init/ztreambox-wait.conf -O /etc/init/ztreambox-wait.conf
#wget http://remaster.ztreambox.org/etc/init/ztreambox.conf -O /etc/init/ztreambox.conf
cp zbremaster/etc/init/ztreambox-wait.conf /etc/init/ztreambox-wait.conf
cp zbremaster/etc/init/ztreambox.conf /etc/init/ztreambox.conf
chmod +x /etc/init/*.conf

#copy setup.d scripts
if [ ! -d "/etc/ztreambox/setup.d" ]; then
	mkdir -p /etc/ztreambox/setup.d
fi
rm -f /etc/ztreambox/setup.d/*.sh
#wget http://remaster.ztreambox.org/etc/setup.d/01-configureXorg.sh -O /etc/ztreambox/setup.d/01-configureXorg.sh
#wget http://remaster.ztreambox.org/etc/setup.d/02-configNVIDIAHDMI.sh -O /etc/ztreambox/setup.d/02-configNVIDIAHDMI.sh
#wget http://remaster.ztreambox.org/etc/setup.d/03-configNVIDIAasoundrc.sh -O /etc/ztreambox/setup.d/03-configNVIDIAasoundrc.sh
#wget http://remaster.ztreambox.org/etc/setup.d/04-configAMDFusionasoundrc.sh -O /etc/ztreambox/setup.d/04-configAMDFusionasoundrc.sh
#wget http://remaster.ztreambox.org/etc/setup.d/05-configGenericasoundrc.sh -O /etc/ztreambox/setup.d/05-configGenericasoundrc.sh
cp zbremaster/etc/setup.d/01-configureXorg.sh /etc/ztreambox/setup.d/01-configureXorg.sh
cp zbremaster/etc/setup.d/02-configNVIDIAHDMI.sh /etc/ztreambox/setup.d/02-configNVIDIAHDMI.sh
cp zbremaster/etc/setup.d/03-configNVIDIAasoundrc.sh /etc/ztreambox/setup.d/03-configNVIDIAasoundrc.sh
cp zbremaster/etc/setup.d/04-configAMDFusionasoundrc.sh /etc/ztreambox/setup.d/04-configAMDFusionasoundrc.sh
cp zbremaster/etc/setup.d/05-configGenericasoundrc.sh /etc/ztreambox/setup.d/05-configGenericasoundrc.sh
chmod +x /etc/ztreambox/setup.d/*.sh

) 2>&1 | tee 63-initscripts.log