#!/bin/bash

#create a /etc/resolv.conf file if it is`nt there
if [ ! -f "/etc/resolv.conf" ]; then
	cd /run/resolvconf
	touch resolv.conf
	echo "nameserver 127.0.0.1" > resolv.conf
	cd /etc
	ln -s /run/resolvconf/resolv.conf
	resolvconf -u
fi

exit 0