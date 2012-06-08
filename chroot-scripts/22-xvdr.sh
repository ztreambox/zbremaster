#!/bin/bash

clear
echo "##################################################"
echo "# compiling xvdr ...                             #"
echo "##################################################"
sleep 3

(

#install needed packages 
apt-get install --yes git-core cdbs dpatch zlib1g-dev libtool automake

#already installed by vdr
# if [ ! -d "/usr/src/vdr-plugin-xvdr" ]; then
	# #vdr-plugin-xvdr
	# cd /usr/src/
	# git clone https://github.com/pipelka/vdr-plugin-xvdr.git
	# cd /usr/src/vdr-plugin-xvdr
	# dpkg-buildpackage -rfakeroot -us -uc -b
	# cd ..
	# dpkg -i vdr-plugin-xvdr*.deb
# else
	# #Bei einem Update
	# cd /usr/src/vdr-plugin-xvdr
	# git pull https://github.com/pipelka/vdr-plugin-xvdr.git
	# dpkg-buildpackage -rfakeroot -us -uc -b
	# cd ..
	# dpkg -i vdr-plugin-xvdr*.deb
# fi

if [ ! -d "/usr/src/xbmc-addon-xvdr" ]; then
	#xbmc-addon-xvdr
	cd /usr/src
	git clone https://github.com/pipelka/xbmc-addon-xvdr.git
	cd xbmc-addon-xvdr
	sh autogen.sh
	./configure --prefix=/usr/lib/xbmc
	#mkdir /etc/skel/.xbmc
	#./configure --prefix=/etc/skel/.xbmc
	make
	make install
else
	#when updating
	cd /usr/src/xbmc-addon-xvdr
	git pull https://github.com/pipelka/xbmc-addon-xvdr.git
	sh autogen.sh
	./configure --prefix=/usr/lib/xbmc
	make
	make install	
fi

#uninstall unneeded packages
apt-get autoremove --yes git-core cdbs dpatch zlib1g-dev libtool automake

cd /
dpkg-query -W --showformat='${Package} ${Version}\n' > 14-xvdr-packages.txt

) 2>&1 | tee 22-xvdr.log
