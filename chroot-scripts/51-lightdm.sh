#!/bin/bash

clear
echo "##################################################"
echo "# configuring lightdm ...                        #"
echo "##################################################"
sleep 3

(

#lightdm.conf
rm -f /etc/lightdm/lightdm.conf
cat << EOF | tee /etc/lightdm/lightdm.conf
[SeatDefaults]
autologin-user=xbmc
autologin-user-timeout=0
autologin-session=lightdm-autologin
user-session=XBMC
greeter-session=unity-greeter
autologin-guest=false
allow-guest=false

EOF

) 2>&1 | tee 51-lightdm.log
