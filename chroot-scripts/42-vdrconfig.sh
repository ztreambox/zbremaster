#!/bin/bash

clear
echo "##################################################"
echo "# configuring vdr ...                            #"
echo "##################################################"
sleep 3

export VDRDIR="vdr-1.7.23"
#export VDRDIR="vdr-1.7.27"

(

#plugin-streamdev-server
mkdir /etc/vdr/plugins/streamdev-server
mv /etc/vdr/plugins/streamdevhosts.conf /etc/vdr/plugins/streamdev-server/streamdevhosts.conf
rm -f /var/lib/vdr/plugins/streamdev-server/*
ln -s /etc/vdr/plugins/streamdev-server/streamdevhosts.conf /var/lib/vdr/plugins/streamdev-server/streamdevhosts.conf
chown -R vdr:vdr /var/lib/vdr/plugins/streamdev-server
sed -i 's/#0/0/' /etc/vdr/plugins/streamdev-server/streamdevhosts.conf

#plugin-live
sed -i 's/# --epgimages/--epgimages/' /etc/vdr/plugins/plugin.live.conf

#svdrp
sed -i 's/#0/0/' /etc/vdr/svdrphosts.conf

#xvdr
sed -i 's/#0/0/' /var/lib/vdr/plugins/xvdr/allowed_hosts.conf

#/var/lib/vdr/setup.conf
rm -f /var/lib/vdr/setup.conf
#wget http://remaster.ztreambox.org/$VDRDIR/setup.conf -O /var/lib/vdr/setup.conf
cp zbremaster/$VDRDIR/setup.conf -O /var/lib/vdr/setup.conf
chown vdr:vdr /var/lib/vdr/setup.conf
#set MinUserInactivity = 0
#set UpdateChannels = 0

#channels.conf
rm -f /var/lib/vdr/channels.conf
#wget http://remaster.ztreambox.org/dvb/channels.conf -O /var/lib/vdr/channels.conf
cp zbremaster/dvb/channels.conf -O /var/lib/vdr/channels.conf
chown vdr:vdr /var/lib/vdr/channels.conf

#remote.conf
touch /var/lib/vdr/remote.conf
chown vdr:vdr /var/lib/vdr/remote.conf

#/etc/default/vdr
sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/vdr
sed -i 's/ENABLE_SHUTDOWN=1/ENABLE_SHUTDOWN=0/' /etc/default/vdr
sed -i '$a\ ' /etc/default/vdr
sed -i '$a\#Video-Directory' /etc/default/vdr
sed -i '$a\VIDEO_DIR="/home/xbmc/Recordings"' /etc/default/vdr
sed -i '$a\ ' /etc/default/vdr
sed -i '$a\#LIRC' /etc/default/vdr
sed -i '$a\LIRC=/dev/null' /etc/default/vdr
sed -i '$a\ ' /etc/default/vdr
sed -i '$a\#umask for new files and directories' /etc/default/vdr
sed -i '$a\umask 002' /etc/default/vdr
sed -i '$a\ ' /etc/default/vdr

#logging
sed -i 's/REC_CMD/REC_CMD --log=1/' /etc/init.d/vdr

#vdr.groups
sed -i '$a\xbmc' /etc/vdr/vdr.groups

) 2>&1 | tee 42-vdrconfig.log
