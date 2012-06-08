#!/bin/bash

clear
echo "##################################################"
echo "# including ztreambox scripts ...                #"
echo "##################################################"
sleep 3

(

#getting ztreambox scripts
mkdir -p /etc/skel/zbscripts/
cd /etc/skel/zbscripts
wget --mirror -m -np -nH --cut-dirs=1 -A.sh http://remaster.ztreambox.org/zbscripts
chmod +x /etc/skel/zbscripts/*.sh
cd /

#xbmc advanced launcher configuration
mkdir -p /etc/skel/.xbmc/userdata/addon_data/plugin.program.advanced.launcher/{fanarts,nfos,thumbs}
if [ -f "lang.de" ]; then
	wget http://remaster.ztreambox.org/zbmenu/launchers-de.xml -O /etc/skel/.xbmc/userdata/addon_data/plugin.program.advanced.launcher/launchers.xml
else
	wget http://remaster.ztreambox.org/zbmenu/launchers-en.xml -O /etc/skel/.xbmc/userdata/addon_data/plugin.program.advanced.launcher/launchers.xml
fi

# #getting ztreambox menu
# mkdir -p /etc/skel/.local/share/applications
# wget http://remaster.ztreambox.org/zbmenu/ztreambox.desktop -O /etc/skel/.local/share/applications/ztreambox.desktop

) 2>&1 | tee 64-zbscripts.log