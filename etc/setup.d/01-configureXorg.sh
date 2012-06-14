#!/bin/bash

#      Copyright (C) 2005-2008 Team XBMC
#      http://www.xbmc.org
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with XBMC; see the file COPYING.  If not, write to
#  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#  http://www.gnu.org/copyleft/gpl.html
#
# original script modified by Holger (ztreambox.org)
# original script can be found here:
# https://github.com/xbmc/XBMCbuntu/blob/master/Files/config/includes.chroot/etc/xbmc/setup.d/01-configureXorg.sh
#

xbmcUser=xbmc

#
# Generates valid xorg.conf for proprietary drivers
#

if [ -e /etc/X11/xorg.conf ] ; then
	rm -f /etc/X11/xorg.conf
fi

# Identify GPU, Intel by default
GPUTYPE="INTEL"

GPU=$(lspci -nn | grep 0300)
# 10de == NVIDIA
if [ "$(echo $GPU | grep 10de)" ]; then
	GPUTYPE="NVIDIA"
else
        # 1002 == AMD
        if [ "$(echo $GPU | grep 1002)" ]; then
            GPUTYPE="AMD"
		fi
fi

# Debug info
echo "--Debug info--" > /tmp/debugInfo.txt
echo "--cmdline" >> /tmp/debugInfo.txt
cat /proc/cmdline  >> /tmp/debugInfo.txt
echo "--GPU type: $GPUTYPE" >> /tmp/debugInfo.txt

if [ "$GPUTYPE" = "NVIDIA" ]; then

	#update-alternatives
	update-alternatives --set i386-linux-gnu_gl_conf /usr/lib/nvidia-current/ld.so.conf
	ldconfig
	# run nvidia-xconfig
	/usr/bin/nvidia-xconfig -s --no-logo --no-composite --no-dynamic-twinview --flatpanel-properties="Scaling = Native" --force-generate
	#set HWCursor Off
	sed -i -e 's%Section \"Screen\"%&\n    Option      \"HWCursor\" \"Off\"%' /etc/X11/xorg.conf
	#activate vdpau in xbmc
	sed -i 's/<usevdpau>false<\/usevdpau>/<usevdpau>true<\/usevdpau>/' /home/$xbmcUser/.xbmc/userdata/guisettings.xml
	#deactivate vaapi in xbmc
	sed -i 's/<usevaapi>true<\/usevaapi>/<usevaapi>false<\/usevaapi>/' /home/$xbmcUser/.xbmc/userdata/guisettings.xml

	#as this is a nvidia system we can create a proper advancedsettings.xml file
cat << EOF | tee /home/$xbmcUser/.xbmc/userdata/advancedsettings.xml
<advancedsettings>
	<cputempcommand>sensors|sed -ne "s/Core 1: \+[-+]\([0-9]\+\).*/\1 C/p"</cputempcommand>
	<gputempcommand>echo "\$(nvidia-settings -tq gpuCoreTemp) C"</gputempcommand>
	<audio>
		<resample>48000</resample>
	</audio>
	<videoextensions>
		<remove>.url|.xml</remove>
	</videoextensions>
	<network>
		<disableipv6>true</disableipv6>
	</network>
</advancedsettings>
EOF
	
fi

if [ "$GPUTYPE" = "AMD" ]; then

	# Try fglrx first
	update-alternatives --set i386-linux-gnu_gl_conf /usr/lib/fglrx/ld.so.conf
	ldconfig
	# run aticonfig
	/usr/lib/fglrx/bin/aticonfig --initial --sync-vsync=on -f
	/usr/lib/fglrx/bin/aticonfig --set-pcs-val=MCIL,DigitalHDTVDefaultUnderscan,0
	ATICONFIG_RETURN_CODE=$?
	#deactivate vdpau in xbmc
	sed -i 's/<usevdpau>true<\/usevdpau>/<usevdpau>false<\/usevdpau>/' /home/$xbmcUser/.xbmc/userdata/guisettings.xml
	#activate vaapi in xbmc
	sed -i 's/<usevaapi>false<\/usevaapi>/<usevaapi>true<\/usevaapi>/' /home/$xbmcUser/.xbmc/userdata/guisettings.xml
	
	#as this is a amd system we can create a proper advancedsettings.xml file
cat << EOF | tee /home/$xbmcUser/.xbmc/userdata/advancedsettings.xml
<advancedsettings>
	<cputempcommand>sensors|sed -ne "s/temp1: \+[-+]\([0-9]\+\).*/\1 C/p"</cputempcommand>
	<gputempcommand>echo "\$(aticonfig --odgt | grep Temp | awk -F'- ' '{ print \$2 }' | awk -F'.' '{ print \$1 }') C"</gputempcommand>
	<audio>
		<resample>48000</resample>
	</audio>
	<videoextensions>
		<remove>.url|.xml</remove>
	</videoextensions>
	<network>
		<disableipv6>true</disableipv6>
	</network>
</advancedsettings>
EOF
	
	if [ $ATICONFIG_RETURN_CODE -eq 255 ]; then
		# aticonfig returns 255 on old unsuported ATI cards
		# Let the X default ati driver handle the card

		# revert to mesa
		update-alternatives --set i386-linux-gnu_gl_conf /usr/lib/i386-linux-gnu/mesa/ld.so.conf

		# TODO cleanup environment and guisettings
		ldconfig

		modprobe radeon # Required to permit KMS switching and support hardware GL
	fi

fi

if [ "$GPUTYPE" = "INTEL" ]; then

	#as this is a intel system we can create a proper advancedsettings.xml file
cat << EOF | tee /home/$xbmcUser/.xbmc/userdata/advancedsettings.xml
<advancedsettings>
	<cputempcommand>sensors|sed -ne "s/temp1: \+[-+]\([0-9]\+\).*/\1 C/p"</cputempcommand>
	<gputempcommand></gputempcommand>
	<audio>
		<resample>48000</resample>
	</audio>
	<videoextensions>
		<remove>.url|.xml</remove>
	</videoextensions>
	<network>
		<disableipv6>true</disableipv6>
	</network>
</advancedsettings>
EOF
	
fi

# Debug
if [ -f /etc/X11/xorg.conf ] ; then
	echo "--xorg.conf" >> /tmp/debugInfo.txt
	cat /etc/X11/xorg.conf >> /tmp/debugInfo.txt
else
	echo "No xorg.conf" >> /tmp/debugInfo.txt
fi

echo "--ps" >> /tmp/debugInfo.txt
ps aux >> /tmp/debugInfo.txt

exit 0