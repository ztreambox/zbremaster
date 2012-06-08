#!/bin/bash

clear
echo "##################################################"
echo "# installing dvb drivers ...                     #"
echo "##################################################"
sleep 3

(

#Sundtek mediaclient
echo " "
echo "### sundtek dvb drivers ##########################"
echo " "
ISCONFED=`dpkg -s sundtek-netinst-driver | grep 'install ok installed'`
if [ -z "$ISCONFED" ]; then
	wget http://sundtek.de/media/sundtek-netinst-driver.deb
	dpkg -i sundtek-netinst-driver.deb
	rm -f sundtek-netinst-driver.deb
	#report installed packages
	dpkg-query -W --showformat='${Package} ${Version}\n' > 16-dvbdriver-packages.txt
fi

) 2>&1 | tee 24-dvbdrivers.log
