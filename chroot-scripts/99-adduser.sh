#!/bin/bash

clear
echo "##################################################"
echo "# adding xbmc user ...                           #"
echo "##################################################"
sleep 3

(

#create the user xbmc
useradd --skel /etc/skel --shell /bin/bash --create-home --user-group xbmc
#create a password for the user
echo -e "xbmc\nxbmc\n" | passwd xbmc
#samba password for xbmc user
echo -e "xbmc\nxbmc\n" | smbpasswd -a -s xbmc
#add user xbmc to needed groups
usermod -a -G adm xbmc
usermod -a -G audio xbmc
usermod -a -G cdrom xbmc
usermod -a -G dip xbmc
usermod -a -G plugdev xbmc
usermod -a -G sambashare xbmc
usermod -a -G sudo xbmc
usermod -a -G video xbmc

# #add user hts (tvheadend) to video and xbmc group
# usermod -a -G video hts
# usermod -a -G xbmc hts

#add user xbmc to group vdr
usermod -a -G vdr xbmc
#add user vdr to group xbmc
usermod -a -G xbmc vdr

#write rights for group in /home/xbmc/Recordings
#needed for vdr to save recordings in this directory
chmod g+w /home/xbmc/Recordings

#set lightdm user session for user xbmc
cat << EOF | tee /home/xbmc/.dmrc

[Desktop]
Session=XBMC
EOF
chown xbmc:xbmc /home/xbmc/.dmrc

#add xbmc user to sudoers
echo '#' >> /etc/sudoers
echo '#xbmc user can run any sudo command without a password' >> /etc/sudoers
echo 'xbmc ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

#create .bash_history file
touch /home/xbmc/.bash_history
chown xbmc:xbmc /home/xbmc/.bash_history

#nfs config
exportfs -ra

) 2>&1 | tee 99-adduser.log
