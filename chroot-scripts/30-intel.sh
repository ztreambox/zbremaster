#!/bin/bash

clear
echo "##################################################"
echo "# setting intel graphics driver as default ...   #"
echo "##################################################"
sleep 3

(

update-alternatives --set i386-linux-gnu_gl_conf /usr/lib/i386-linux-gnu/mesa/ld.so.conf
ldconfig

) 2>&1 | tee 30-intel.log
