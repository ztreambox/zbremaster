#!/bin/bash

clear
echo "##################################################"
echo "# configuring additional packages ...            #"
echo "##################################################"
sleep 3

(

#ntp config
if [ -f "lang.de" ]; then
	ISCONFED=`grep 0.de.pool.ntp.org /etc/ntp.conf`
	if [ -z "$ISCONFED" ]; then
		sed -i '17iserver 0.de.pool.ntp.org' /etc/ntp.conf
		sed -i '18iserver 1.de.pool.ntp.org' /etc/ntp.conf
		sed -i '19iserver 2.de.pool.ntp.org' /etc/ntp.conf
		sed -i '20iserver 3.de.pool.ntp.org' /etc/ntp.conf
	fi
else
	ISCONFED=`grep 0.pool.ntp.org /etc/ntp.conf`
	if [ -z "$ISCONFED" ]; then
		sed -i '17iserver 0.pool.ntp.org' /etc/ntp.conf
		sed -i '18iserver 1.pool.ntp.org' /etc/ntp.conf
		sed -i '19iserver 2.pool.ntp.org' /etc/ntp.conf
		sed -i '20iserver 3.pool.ntp.org' /etc/ntp.conf
	fi
fi

#nfs config
ISCONFED=`grep 192.168.0.0 /etc/exports`
if [ -z "$ISCONFED" ]; then
	echo '/home/xbmc 192.168.0.0/255.255.0.0(rw,async,no_subtree_check)' >> /etc/exports
	mkdir /etc/exports.d
fi

#samba config
ISCONFED=`grep 'workgroup = HOME' /etc/samba/smb.conf`
if [ -z "$ISCONFED" ]; then
	sed -i 's/workgroup = WORKGROUP/workgroup = HOME/' /etc/samba/smb.conf
	sed -i 's/server string = %h server (Samba, Ubuntu)/server string = %h/' /etc/samba/smb.conf
	sed -i 's/#   security = user/   security = user/' /etc/samba/smb.conf
	sed -i 's/;\[homes\]/\[homes\]/' /etc/samba/smb.conf
	sed -i 's/;   comment = Home Directories/   comment = Home Directories/' /etc/samba/smb.conf
	sed -i 's/;   browseable = no/   browseable = yes/' /etc/samba/smb.conf
	sed -i 's/;   read only = yes/   read only = no/' /etc/samba/smb.conf
	sed -i 's/;   create mask = 0700/   create mask = 0775/' /etc/samba/smb.conf
	sed -i 's/;   directory mask = 0700/   directory mask = 0775/' /etc/samba/smb.conf
	sed -i 's/;   valid users = %S/   valid users = %S/' /etc/samba/smb.conf
fi

#proftpd config
ISCONFED=`grep ztreambox /etc/proftpd/proftpd.conf`
if [ -z "$ISCONFED" ]; then
	sed -i 's/Debian/ztreambox/' /etc/proftpd/proftpd.conf
	sed -i 's/inetd/standalone/' /etc/proftpd/proftpd.conf
	sed -i 's/# DefaultRoot/DefaultRoot/' /etc/proftpd/proftpd.conf
fi
	
#lm-sensors
ISCONFED=`grep coretemp /etc/modules`
if [ -z "$ISCONFED" ]; then
	echo coretemp >> /etc/modules
	echo k10temp >> /etc/modules
fi

) 2>&1 | tee 40-additionalpackageconfig.log
