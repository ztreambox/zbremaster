#!/bin/bash

clear
echo "##################################################"
echo "# installing needed base packages ...            #"
echo "##################################################"
sleep 3

(

#update repositories
apt-get update

#the ubuntu standard system
apt-get install --yes ubuntu-standard
dpkg-query -W --showformat='${Package} ${Version}\n' > 01-ubuntu-standard-packages.txt

#complete generic linux kernel
apt-get install --yes linux-generic-pae
dpkg-query -W --showformat='${Package} ${Version}\n' > 02-kernel-packages.txt

#minimal xorg x server
apt-get install --yes xserver-xorg-video-intel xserver-xorg-video-vesa xserver-xorg-video-fbdev
dpkg-query -W --showformat='${Package} ${Version}\n' > 03-xorg-packages.txt

#display manager and greeter
apt-get install --yes lightdm unity-greeter
dpkg-query -W --showformat='${Package} ${Version}\n' > 04-lightdm-packages.txt

#the ubuntu desktop system 
apt-get install --yes --no-install-recommends ubuntu-desktop
dpkg-query -W --showformat='${Package} ${Version}\n' > 05-ubuntu-desktop-packages.txt

#recommended packages needed because of --no-install-recommends
apt-get install --yes acpi-support \
activity-log-manager-control-center \
app-install-data-partner \
apport-gtk \
avahi-autoipd \
avahi-daemon \
avahi-utils \
bluez \
bluez-alsa \
bluez-gstreamer \
branding-ubuntu \
curl \
gcc \
gnome-bluetooth \
gnome-disk-utility \
gvfs-fuse \
ibus \
ibus-gtk3 \
ibus-pinyin \
ibus-pinyin-db-android \
ibus-table \
im-switch \
jockey-gtk \
kerneloops-daemon \
laptop-detect \
libnss-mdns \
libpam-gnome-keyring \
libproxy1-plugin-gsettings \
libproxy1-plugin-networkmanager \
libqt4-sql-sqlite \
libwmf0.2-7-gtk \
make \
mousetweaks \
nautilus-share \
network-manager-gnome \
network-manager-pptp \
network-manager-pptp-gnome \
overlay-scrollbar \
plymouth-theme-ubuntu-logo \
policykit-desktop-privileges \
pulseaudio-module-bluetooth \
pulseaudio-module-gconf \
pulseaudio-module-x11 \
python-aptdaemon.pkcompat \
qt-at-spi \
sni-qt \
ttf-ubuntu-font-family \
xcursor-themes \
xdg-utils
#additional extra packages needed for ubuntu-desktop
apt-get install --yes appmenu-gtk \
appmenu-gtk3 \
appmenu-qt \
apt-xapian-index \
discover \
gir1.2-atspi-2.0 \
gir1.2-dbusmenu-glib-0.4 \
gir1.2-dbusmenu-gtk-0.4 \
gir1.2-dee-1.0 \
gir1.2-gnomekeyring-1.0 \
gir1.2-gst-plugins-base-0.10 \
gir1.2-gudev-1.0 \
gir1.2-indicate-0.7 \
gir1.2-launchpad-integration-3.0 \
gir1.2-unity-5.0 \
gir1.2-wnck-3.0 \
indicator-appmenu \
libcanberra-gstreamer \
libcanberra-gtk-module \
libcanberra-pulse \
notify-osd-icons \
qdbus \
sessioninstaller \
smbclient \
ssl-cert \
ubuntu-sso-client-gtk \
unity-lens-applications \
unity-lens-files \
unity-lens-video \
update-inetd \
zeitgeist
dpkg-query -W --showformat='${Package} ${Version}\n' > 06-ubuntu-desktop-extra-packages.txt

#ubuntu live cd installer
apt-get install --yes ubiquity ubiquity-frontend-gtk ubiquity-slideshow-ubuntu ubiquity-casper
dpkg-query -W --showformat='${Package} ${Version}\n' > 07-ubiquity-packages.txt

# #hardware identification system
# apt-get install --yes discover laptop-detect os-prober
# dpkg-query -W --showformat='${Package} ${Version}\n' > 08-discover-packages.txt

#run a "live" preinstalled system from read-only media
apt-get install --yes casper lupin-casper
dpkg-query -W --showformat='${Package} ${Version}\n' > 08-casper-packages.txt

#Language Pack
if [ -f "lang.de" ]; then
	apt-get install --yes language-pack-de language-pack-de-base language-pack-gnome-de language-pack-gnome-de-base \
wngerman wogerman wswiss hunspell-de-de
else
	apt-get install --yes language-pack-en language-pack-en-base language-pack-gnome-en language-pack-gnome-en-base
fi
dpkg-query -W --showformat='${Package} ${Version}\n' > 09-language-packages.txt

#purge some unneeded extra packages
apt-get purge --yes firefox-locale-de firefox-locale-en ubuntu-docs

#documentation of installed packages
dpkg -l | grep -e "^ii.*" > 10-ztreambox-base-packages.txt

) 2>&1 | tee 10-basepackages.log
