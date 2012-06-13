#!/bin/bash
#######################################################################
#Skriptname: airvideo-server.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Skript zur des AirVideoServers
#http://ubuntuguide.net/stream-videos-to-iphoneipad-with-airvideo-in-ubuntu-11-0410-1010-04
#http://irrationale.com/2011/03/31/airvideo-on-ubuntu-the-even-easier%C2%A0way/
#https://launchpad.net/~rubiojr/+archive/airvideo
#
#Changelog:
#
#ToDo:
# 
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="AirVideoServer Installation:"
	TITLE2="AirVideoServer Deinstallation:"
	TITLE3="Internetverbindung:"
	TEXT1="AirVideoServer ist bereits installiert! Deinstallieren?"
	TEXT2="Soll AirVideoServer installiert werden?"
	TEXT3="# Paketquellen hinzufuegen..."
	TEXT4="# Paketquellen aktualisieren..."
	TEXT5="# airvideo-server installieren..."
	TEXT6="# zusaetzliche Pakete installieren..."
	TEXT7="# Konfiguration anpassen..."
	TEXT8="# Autostart konfigurieren..."
	TEXT9="# AirVideoServer installiert!"
	TEXT10="AirVideoServer wird installiert..."
	TEXT11="Installation wurde durch Benutzer abgebrochen!"
	TEXT12="Aktion abgebrochen!"
	TEXT13="# Autostart wird deaktiviert..."
	TEXT14="# airvideo-server wird deinstalliert..."
	TEXT15="# AirVideoServer deinstalliert!"
	TEXT16="AirVideoServer wird deinstalliert..."
	TEXT17="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"

else

	TITLE1="AirVideoServer installation:"
	TITLE2="AirVideoServer deinstallation:"
	TITLE3="Internet connection:"
	TEXT1="AirVideoServer already installed! Uninstall?"
	TEXT2="Should AirVideoServer be installied?"
	TEXT3="# adding package sources..."
	TEXT4="# update package sources..."
	TEXT5="# installing airvideo-server..."
	TEXT6="# installing additional packages..."
	TEXT7="# changing configuration..."
	TEXT8="# configuring autostart..."
	TEXT9="# AirVideoServer installed!"
	TEXT10="AirVideoServer going to be installed..."
	TEXT11="Installation abortd by user!"
	TEXT12="Action cancled!"
	TEXT13="# deactivating autostart..."
	TEXT14="# uninstalling airvideo-server..."
	TEXT15="# AirVideoServer unnstalled!"
	TEXT16="Uninstalling AirVideoServer..."
	TEXT17="No internet connection, installation not possible. Please check your network configuration"

fi

###############################################################################
#Funktion zur Erkennung ob AirVideoServer installiert ist
function detectairvideo {

   if [ -f "/opt/airvideo-server/AirVideoServerLinux.properties" ]; then
	  zenity --question --title="${TITLE1}" --text="${TEXT1}"
	  if [ "$?" = 0 ]; then
	     deinstairvideo
	  else
	     exit 1
	  fi
   else
      instairvideo
   fi

}
###############################################################################

###############################################################################
#Funktion zur Installation von AirVideoServer
function instairvideo {

	zenity --question --title="${TITLE1}" --text="${TEXT2}"

	if [ "$?" = 0 ]; then

    (
    #kleine Denkpause
	sleep 2
	#Repository hinzufügen
    echo "${TEXT3}" ; sleep 2
	sudo add-apt-repository -y ppa:rubiojr/airvideo
	#Paketquellen aktualisieren
	echo "${TEXT4}" ; sleep 2
	sudo apt-get update -y
	#Paket installieren
    echo "${TEXT5}" ; sleep 2
	sudo apt-get install -y airvideo-server
	
	echo "${TEXT6}" ; sleep 2
	sudo apt-get install -y --force-yes libavcodec53 libavcodec-extra-53 libmp4v2-2
	# wget http://archive.ubuntu.com/ubuntu/pool/multiverse/m/mpeg4ip/mpeg4ip-server_1.6dfsg-0.2ubuntu9_i386.deb
	# sudo dpkg -i --force-all mpeg4ip-server_1.6dfsg-0.2ubuntu9_i386.deb
	# rm -f mpeg4ip-server_1.6dfsg-0.2ubuntu9_i386.deb
	
	#anpassen der Konfigurationsdatei /opt/airvideo-server/AirVideoServerLinux.properties
	echo "${TEXT7}" ; sleep 2
	sudo rm -f /opt/airvideo-server/AirVideoServerLinux.properties
	cat << EOF | sudo tee /opt/airvideo-server/AirVideoServerLinux.properties
path.ffmpeg = /opt/airvideo-server/bin/ffmpeg
path.mp4creator = /usr/bin/mp4creator
path.faac = /usr/bin/faac
password =
subtitles.encoding = windows-1250
subtitles.font = Verdana
#folders = Movies:/home/user/Movies,Series:/home/user/Series
folders = Videos:/home/xbmc/Videos
EOF

	#sudo sed -i "s/folders/#folders/" /opt/airvideo-server/AirVideoServerLinux.properties
	#sudo sh -c "echo 'folders = Videos:/home/xbmc/Videos' >> /opt/airvideo-server/AirVideoServerLinux.properties"

	#Autostart konfigurieren
	echo "${TEXT8}" ; sleep 2

	#Autostart für upstart konfigurieren
	sudo rm -f /etc/init/airvideo.conf
	cat << EOF | sudo tee /etc/init/airvideo.conf
description "Air Video Server"  
start on runlevel [2345]  
stop on shutdown  
	
respawn  
  
exec sudo -H -n -u xbmc /usr/bin/java -jar /opt/airvideo-server/AirVideoServerLinux.jar /opt/airvideo-server/AirVideoServerLinux.properties
EOF

	echo "${TEXT9}"
    ) | zenity --progress --title="${TITLE1}" --text="${TEXT10}" --pulsate
	
		#Rechner neu starten !!!
		if [ "$?" = 1 ]; then
			zenity --warning --title="${TITLE1}" --text="${TEXT11}"
		else
			sudo start airvideo
			exit 1
		fi
	else
      #Abbrechen
      zenity --info --title="${TITLE1}" --text="${TEXT12}"
      exit 1
   fi

}
###############################################################################

###############################################################################
#Funktion zur Deinstallation von AirVideoServer
function deinstairvideo {

   (
   #Autostart deaktivieren
   echo "${TEXT13}" ; sleep 2
   #sudo /etc/init.d/airvideo-server stop
   #sudo update-rc.d -f airvideo-server remove
   #sudo rm -f /etc/init.d/airvideo-server
   sudo airvideo-server stop
   sudo rm -f /etc/init/airvideo.conf
   #Paket deinstallieren
   echo "${TEXT14}" ; sleep 2
   sudo dpkg -P mpeg4ip-server
   sudo apt-get purge -y --force-yes libavcodec53 libavcodec-extra-53 libmp4v2-2
   sudo apt-get purge -y --force-yes airvideo-server
   sudo apt-get autoremove -y --force-yes
   echo "${TEXT15}"
   ) | zenity --progress --title="${TITLE2}" --text="${TEXT16}" --pulsate

}
###############################################################################

###############################################################################
#Funktion zur Überprüfung der Internetverbindung
function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE3}" --text="${TEXT17}"
      exit 1
   else 
      #Aufruf der Funktion detectairvideo
	  detectairvideo
   fi

}
###############################################################################

#Aufruf der Funktion checkconnection
checkconnection
