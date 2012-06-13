#!/bin/bash
#######################################################################
#Skriptname: tvlogopack.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Installiert TV Logopack aus http://forum.xbmc.org/showthread.php?t=86047
#
#Changelog:
#
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="TVLogopack-Installation:"
	TITLE2="Internetverbindung:"
	TEXT1="Soll das TVLogopack installiert werden?"
	TEXT2="# TV Logopack wird geholt..."
	TEXT3="# TV Logopack wird ausgepackt..."
	TEXT4="# TV Logopack eingespielt! Bitte in Live-TV Einstellungen 'Suche fehlende Kanallogos' ausfuehren!"
	TEXT5="TV Logopack wird eingespielt..."
	TEXT6="Aktion abgebrochen!"
	TEXT7="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"

else

	TITLE1="TVLogopack installation:"
	TITLE2="Internet connection:"
	TEXT1="Should TVLogopack be installed?"
	TEXT2="# Downloading TV Logopack..."
	TEXT3="# Unpacking TV Logopack..."
	TEXT4="# TV Logopack installed! Please run 'scan for missing icons' in Live-TV Settings!"
	TEXT5="TV Logopack is being installed..."
	TEXT6="Action canceled!"
	TEXT7="No internet connection, installation not possible. Please check your network configuration"

fi

###############################################################################
#Funktion zur Installation von TVLogopack
function insttvlogopack {

zenity --question --title="${TITLE1}" --text="${TEXT1}"

if [ "$?" = 0 ]; then

	(
	sleep 2
	cd ~/.xbmc/tvlogos
	echo "${TEXT2}" ; sleep 2
	wget http://remaster.ztreambox.org/dvb/Logopack.zip
	echo "${TEXT3}" ; sleep 2
	unzip -o Logopack.zip
	#heruntergeladenes Archiv wieder löschen
	rm -f Logopack.zip
	echo "${TEXT4}"
	) | zenity --progress --title="${TITLE1}" --text="${TEXT5}" --pulsate

else
    #Abbrechen
    zenity --info --title="${TITLE1}" --text="${TEXT6}"
    exit 1
fi
   
}

###############################################################################
#Funktion zur Überprüfung der Internetverbindung
function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE2}" --text="${TEXT7}"
      exit 1
   else 
      #Aufruf der Funktion detecthttpr
	  insttvlogopack
   fi

}
###############################################################################

#Aufruf der Funktion checkconnection
checkconnection
