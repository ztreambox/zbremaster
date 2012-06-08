#!/bin/bash

#find out what sinks are present
SINKLIST=`pactl list sinks | grep Sink | awk -F'#' '{ print $2" " }'`
#set pulseaudio master volume for each sink to 100%
for s in $SINKLIST; do
	pactl set-sink-volume $s 100%
done

exit 0