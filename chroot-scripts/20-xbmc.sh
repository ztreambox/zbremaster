#!/bin/bash

clear
echo "##################################################"
echo "# installing xbmc ...                            #"
echo "##################################################"
sleep 3

(

ISCONFED=`dpkg -s xbmc | grep 'install ok installed'`
if [ -z "$ISCONFED" ]; then
	wget http://packages.pulse-eight.net/ubuntu/install-xbmc.sh
	chmod +x install-xbmc.sh
	sed -i 's/sudo apt-get -y install xbmc/sudo apt-get -y --force-yes install xbmc/' install-xbmc.sh
	./install-xbmc.sh
	apt-get install -y --force-yes afpfs-ng-utils lcdproc libaacs0 libbluray1 libcrystalhd3
	rm -f install-xbmc.sh
	dpkg-query -W --showformat='${Package} ${Version}\n' > 12-xbmc-packages.txt
fi

# if [ ! -f "/etc/apt/sources.list.d/alexandr-surkov-xbmc-pvr-precise.list" ]; then
	# apt-add-repository -y ppa:alexandr-surkov/xbmc-pvr
# fi
# ISCONFED=`dpkg -s xbmc | grep 'install ok installed'`
# if [ -z "$ISCONFED" ]; then
	# apt-get update
	# apt-get install -y --force-yes xbmc afpfs-ng-utils lcdproc libaacs0 libbluray1 libcec libcrystalhd3 libnfs1 librtmp0 libshairport1 libva-driver-intel xbmc-addon-xvdr
	# #suggested packages
	# #apt-get install -y --force-yes libbluray-bdj libqt3-mt-psql libqt3-mt-mysql libqt3-mt-odbc python-qt3-gl python-qt3-doc
	# #report installed packages
	# dpkg-query -W --showformat='${Package} ${Version}\n' > 11-xbmc-packages.txt
# fi

) 2>&1 | tee 20-xbmc.log
