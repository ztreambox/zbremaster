#!/bin/bash

#update-notifier
gsettings set com.ubuntu.update-notifier auto-launch false
gsettings set com.ubuntu.update-notifier no-show-notifications true
#background
#gsettings set org.gnome.desktop.background picture-uri 'file:///home/xbmc/ztreambox/media/ztreambox.png'
#background primary-color
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.desktop.background show-desktop-icons false
#disable-lock-screen
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
#disable-user-switching
gsettings set org.gnome.desktop.lockdown disable-user-switching true
#media-handling
gsettings set org.gnome.desktop.media-handling automount true
gsettings set org.gnome.desktop.media-handling automount-open false
gsettings set org.gnome.desktop.media-handling autorun-never true
#screensaver
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.gnome.desktop.screensaver lock-enabled false
#event-sounds
gsettings set org.gnome.desktop.sound event-sounds false
#filebrowser
gsettings set org.gnome.gedit.plugins.filebrowser filter-mode []
#workgroup
gsettings set org.gnome.system.smb workgroup 'HOME'

exit 0