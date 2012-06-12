#!/bin/bash
#######################################################################
#Skriptname: syncscript.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Skript zur Synchronistaion des Skript-Verzeichnisses und des ztreambox
#Menüs
#Changelog:
#
#ToDo:
# - 
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="ztreambox SyncSkript:"
	TITLE2="Internetverbindung:"
	TEXT1="ztreambox Skripte und Menuedatei synchronisieren..."
	TEXT2="# ztreambox Skriptverzeichnis wird synchronisiert..."
	TEXT3="# ztreambox Menuedatei wird synchronisiert..."
	TEXT4="# ztreambox Skripte und Menuedatei synchronisiert!"
	TEXT5="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"

else

	TITLE1="ztreambox SyncScript:"
	TITLE2="Internet connection:"
	TEXT1="Synchronizing ztreambox scripts and menu file..."
	TEXT2="# Synchronizing ztreambox script directory..."
	TEXT3="# Synchronizing ztreambox menu file..."
	TEXT4="# ztreambox scripts and menu file synchronized!"
	TEXT5="No internet connection, installation not possible. Please check your network configuration"

fi

SCRIPTDIR="zbscripts/"
MENUDIR="zbmenu"

#Scriptverzeichnis abgleichen
function synchronize {

   (
   sleep 2
   echo "${TEXT2}" ; sleep 2
   #Skriptverzeichnis synchronisieren
   cd ~/zbscripts
   rm -f *.sh
   wget --mirror -m -np -nH --cut-dirs=1 -A.sh http://remaster.ztreambox.org/$SCRIPTDIR
   chmod +x *.*
   echo "${TEXT3}" ; sleep 2
   #Advanced Launcher Datei abgleichen
   if [ "$LANGCONF" = "de_DE.UTF-8" ]; then
	wget http://remaster.ztreambox.org/${MENUDIR}/launchers-de.xml -O ~/.xbmc/userdata/addon_data/plugin.program.advanced.launcher/launchers.xml
   else
    wget http://remaster.ztreambox.org/${MENUDIR}/launchers-en.xml -O ~/.xbmc/userdata/addon_data/plugin.program.advanced.launcher/launchers.xml
   fi
   echo "${TEXT4}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT1}" --pulsate

}

function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE2}" --text="${TEXT5}"
      exit 1
   else 
      #Aufruf der Funktion synchronize
	  synchronize
   fi

}

#Aufruf der Funktion checkconnection
checkconnection
