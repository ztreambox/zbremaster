#!/bin/bash

xbmcUser=xbmc

#
# Exit if asoundrc already exists
#

if [ -f /home/$xbmcUser/.asoundrc ] ; then
	exit 0
fi

#
# Set generic sound variables
#

HDMICARD="0"
HDMIDEVICE="3"

DIGITALCARD="0"
DIGITALDEVICE="1"

ANALOGCARD="0"
ANALOGDEVICE="0"

#
# Setup generic .asoundrc
#

if [ ! -f /home/$xbmcUser/.asoundrc ] ; then
	cat > /home/$xbmcUser/.asoundrc << 'EOF'

pcm.!default {
	type plug
	slave {
		pcm "both"
	}
}

pcm.both {
        type route
        slave {
                pcm multi
                channels 6
        }
        ttable.0.0 1.0
        ttable.1.1 1.0
        ttable.0.2 1.0
        ttable.1.3 1.0
        ttable.0.4 1.0
        ttable.1.5 1.0
}

pcm.multi {
        type multi
        slaves.a {
                pcm "hdmi_hw"
                channels 2
        }
        slaves.b {
                pcm "digital_hw"
                channels 2
        }
        slaves.c {
                pcm "analog_hw"
                channels 2
        }
        bindings.0.slave a
        bindings.0.channel 0
        bindings.1.slave a
        bindings.1.channel 1
        bindings.2.slave b
        bindings.2.channel 0
        bindings.3.slave b
        bindings.3.channel 1
        bindings.4.slave c
        bindings.4.channel 0
        bindings.5.slave c
        bindings.5.channel 1
}

pcm.hdmi_hw {
        type hw
        =HDMICARD=
        =HDMIDEVICE=
        channels 2
}

pcm.hdmi_formatted {
        type plug
        slave {
                pcm hdmi_hw
                rate 48000
                channels 2
        }
}

pcm.hdmi_complete {
        type softvol
        slave.pcm hdmi_formatted
        control.name hdmi_volume
        control.=HDMICARD=
}

pcm.digital_hw {
        type hw
        =DIGITALCARD=
        =DIGITALDEVICE=
        channels 2
}

pcm.analog_hw {
        type hw
        =ANALOGCARD=
        =ANALOGDEVICE=
        channels 2
}
EOF

	sed -i "s/=HDMICARD=/card $HDMICARD/g" /home/$xbmcUser/.asoundrc
	sed -i "s/=HDMIDEVICE=/device $HDMIDEVICE/g" /home/$xbmcUser/.asoundrc

	sed -i "s/=DIGITALCARD=/card $DIGITALCARD/g" /home/$xbmcUser/.asoundrc
	sed -i "s/=DIGITALDEVICE=/device $DIGITALDEVICE/g" /home/$xbmcUser/.asoundrc

	sed -i "s/=ANALOGCARD=/card $ANALOGCARD/g" /home/$xbmcUser/.asoundrc
	sed -i "s/=ANALOGDEVICE=/device $ANALOGDEVICE/g" /home/$xbmcUser/.asoundrc

	chown $xbmcUser:$xbmcUser /home/$xbmcUser/.asoundrc >/dev/null 2>&1 &

fi

#
# Unmute digital output
#

for i in $(aplay -l | grep card | awk '{print $2}' | sed -e 's/\://g' | sort | uniq);
do
	oldifs="$IFS"
	IFS=""
	for line in $(/usr/bin/amixer -c $i | grep 'Simple mixer control' | grep 'IEC958' | awk '{print $4,$5,$6}');
		do
			/usr/bin/amixer -q -c $i sset $line unmute;
		done;
	IFS="$oldifs"
done;

#
# Store alsa settings
#

alsactl store >/dev/null 2>&1 &

# Debug

echo "--alsa asoundrc script" >> /tmp/debugInfo.txt
cat /home/$xbmcUser/.asoundrc >> /tmp/debugInfo.txt
echo "--alsa cpu info" >> /tmp/debugInfo.txt
cat /proc/cpuinfo >> /tmp/debugInfo.txt

exit 0