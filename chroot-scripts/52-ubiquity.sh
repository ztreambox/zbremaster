#!/bin/bash

clear
echo "##################################################"
echo "# configuring ubiquity ...                       #"
echo "##################################################"
sleep 3

(

#getting ztreambox ubiquity slideshow
rm -rf /usr/share/ubiquity-slideshow/slides
rm -f /usr/share/ubiquity-slideshow/slideshow.conf
#wget http://remaster.ztreambox.org/ubiquity-slideshow/ubiquity-slideshow.zip -O /usr/share/ubiquity-slideshow/ubiquity-slideshow.zip
cp zbremaster/ubiquity-slideshow/ubiquity-slideshow.zip /usr/share/ubiquity-slideshow/ubiquity-slideshow.zip
unzip -o /usr/share/ubiquity-slideshow/ubiquity-slideshow.zip -d /usr/share/ubiquity-slideshow/
rm -f /usr/share/ubiquity-slideshow/ubiquity-slideshow.zip

) 2>&1 | tee 52-ubiquity.log
