#!/bin/bash
#######################################################################
#Skriptname: dvbdrivers.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Skript zur Installation von DVB Treibern
#
#Changelog:
#
#ToDo:
# 
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="DVB Treiber:"
	TITLE2="Internetverbindung:"
	TEXT1="Ausgewaehlten DVB Treiber installieren"
	TEXT2="Kein DVB Treiber ausgewaehlt!"
	TEXT3="# Paketquellen aktualisieren..."
	TEXT4="# Paketabhängigkeiten installieren..."
	TEXT5="# Quellcode holen..."
	TEXT6="# media-build Paket kompilieren...dies wird ca. 40 Minuten dauern...Bitte warten..."
	TEXT7="# media-build Paket installieren..."
	TEXT8="# media-build installiert, Rechner wird jetzt neu gestartet!"
	TEXT9="DVB Treiber (media-build) installieren..."
	TEXT10="Installation wurde durch Benutzer abgebrochen!"
	TEXT11="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"
	COLUMN1="PUNKT"
	COLUMN2="BESCHREIBUNG"

else

	TITLE1="DVB drivers:"
	TITLE2="Internet connection:"
	TEXT1="Install choosen DVB driver"
	TEXT2="No DVB driver choosen!"
	TEXT3="# update package sources..."
	TEXT4="# installing package dependencies..."
	TEXT5="# getting source code..."
	TEXT6="# compiling media-build...this will last about 40 minutes...please wait..."
	TEXT7="# installing media-build package..."
	TEXT8="# media-build installed, rebooting PC now!"
	TEXT9="installing DVB driver (media-build)..."
	TEXT10="Installation abortd by user!"
	TEXT11="No internet connection, installation not possible. Please check your network configuration"
	COLUMN1="ITEM"
	COLUMN2="DESCRIPTION"

fi

###############################################################################
#Funktion Auswahlmenü
function menu_de {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE1}" --text="${TEXT1}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" media-build		"DVB-S2 media-build kompilieren und installieren (linuxtv.org)" \
`

if [ -z "$AUSWAHL" ];then
	zenity --info --title="${TITLE1}" --text="${TEXT2}"
elif [ "$AUSWAHL" = media-build ];then
	inst_mediabuild
fi

}

function menu_en {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE1}" --text="${TEXT1}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" media-build		"compile and install DVB-S2 media-build (linuxtv.org)" \
`

if [ -z "$AUSWAHL" ];then
	zenity --info --title="${TITLE1}" --text="${TEXT2}"
elif [ "$AUSWAHL" = media-build ];then
	inst_mediabuild
fi

}
###############################################################################

###############################################################################
#Funktion zum Kompilieren des media-build Pakets von linuxtv.org
function inst_mediabuild {

	(
	#kleine Denkpause
	sleep 2
	#Repositories aktualisieren
    echo "${TEXT3}" ; sleep 2
    sudo apt-get update -y --force-yes
    #Paketabhängigkeiten installieren
    echo "${TEXT4}" ; sleep 2
    sudo apt-get install -y --force-yes git-core dkms build-essential patchutils libdigest-sha-perl libproc-processtable-perl
    #Quellcode holen
    echo "${TEXT5}" ; sleep 2
	cd /usr/src
	sudo git clone http://linuxtv.org/git/media_build.git
    #Paket kompilieren
    echo "${TEXT6}" ; sleep 2	
	cd media_build
	sudo ./build
	#Paket installieren
	echo "${TEXT7}" ; sleep 2
	sudo make install
	echo "${TEXT8}"
	) | zenity --progress --title="${TITLE1}" --text="${TEXT9}" --pulsate

	if [ "$?" = 1 ]; then
      zenity --warning --title="${TITLE1}" --text="${TEXT10}"
	else
      sudo reboot
	fi

}
###############################################################################

###############################################################################
#Funktion zur Überprüfung einer Internetverbindung
function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE2}" --text="${TEXT11}"
      exit 1
   else
      #Aufruf der Funktion menu
      if [ "$LANGCONF" = "de_DE.UTF-8" ]; then
		menu_de
	  else
	    menu_en
	  fi
   fi

}
###############################################################################

#Aufruf der Funktion checkconnection
checkconnection
