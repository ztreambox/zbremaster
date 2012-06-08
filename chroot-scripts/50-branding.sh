#!/bin/bash

clear
echo "##################################################"
echo "# configuring ztreambox branding ...             #"
echo "##################################################"
sleep 3

(

#set background
wget http://remaster.ztreambox.org/media/ztreambox.png -O /usr/share/backgrounds/warty-final-ubuntu.png

#background and logo for login
wget http://remaster.ztreambox.org/media/logo.png -O /usr/share/unity-greeter/logo.png

#unity-greeter config
rm -f /etc/lightdm/unity-greeter.conf
cat << EOF | tee /etc/lightdm/unity-greeter.conf
[greeter]
background=/usr/share/backgrounds/warty-final-ubuntu.png
logo=/usr/share/unity-greeter/logo.png
theme-name=Ambiance
icon-theme-name=ubuntu-mono-dark
font-name=Ubuntu 11
xft-antialias=true
xft-dpi=96
xft-hintstyle=hintslight
xft-rgba=rgb
EOF

# #set distribution informations
# sed -i 's/DISTRIB_ID=.*/DISTRIB_ID=ztreambox/' /etc/lsb-release
# sed -i 's/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION="ztreambox 12.04.01 remix"/' /etc/lsb-release
# echo "ztreambox 12.04.01 remix \n \l" > /etc/issue
# echo "ztreambox 12.04.01 remix" > /etc/issue.net

) 2>&1 | tee 50-branding.log
