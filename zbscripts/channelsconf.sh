#!/bin/bash
#######################################################################
#Skriptname: channelsconf.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Skript zum einfachen wechseln der DVB-T / DVB-S Kanallisten für VDR
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

	TITLE1="DVB Empfangsregion:"
	TITLE2="Internetverbindung:"
	TEXT1="Auswahl aktiviert/erstellt eine passende channels.conf für VDR"
	TEXT2="Keine Empfangsregion ausgewaehlt!"
	TEXT3="vdr ist nicht installiert! Skript wird beendet!"
	TEXT4="# VDR wird gestoppt..."
	TEXT5="# Datei für Empfangsregion wird geholt..."
	TEXT6="# VDR wird gestartet..."
	TEXT7="# Empfangsregion erfolgreich geaendert!"
	TEXT8="Datei fuer Empfangsregion wird angepasst..."
	TEXT9="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"
	COLUMN1="PUNKT"
	COLUMN2="BESCHREIBUNG"

else

	TITLE1="DVB reception area:"
	TITLE2="Internet connection:"
	TEXT1="Selection activates/creates a suitable channels.conf for VDR"
	TEXT2="No reception area selected!"
	TEXT3="vdr not installed! Exiting script!"
	TEXT4="# stopping VDR..."
	TEXT5="# downloading channel list..."
	TEXT6="# starting VDR..."
	TEXT7="# reception area changed!"
	TEXT8="modifying channel list for reception area..."
	TEXT9="No internet connection, installation not possible. Please check your network configuration"
	COLUMN1="ITEM"
	COLUMN2="DESCRIPTION"

fi

###############################################################################
#Funktion Auswahlmenü
function menu_de {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE1}" --text="${TEXT1}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" Manuell			"Manueller Suchlauf (DVB-T/C/S/S2)" \
\"\" Astra              "Bundesweite FreeTV Sender für DVB-S2" \
\"\" Aachen				"NRW, Aachen" \
\"\" Bamberg			"Bayern, Bamberg" \
\"\" Berlin				"Berlin, Brandenburg" \
\"\" Braunschweig		"Niedersachsen, Braunschweig" \
\"\" Bremen				"Norddeutschland, Bremen" \
\"\" Bremerhaven		"Norddeutschland, Bremerhaven" \
\"\" Chemnitz			"Sachsen, Chemnitz" \
\"\" Dortmund			"NRW-Ruhrgebiet, Dortmund" \
\"\" Dresden			"Sachsen, Dresden" \
\"\" Duesseldorf		"NRW-Ruhrgebiet, Düsseldorf" \
\"\" Erfurt				"Thüringen, Erfurt" \
\"\" Hamburg			"Norddeutschland, Hamburg (Rosengarten)" \
\"\" Hannover			"Niedersachsen, Hannover" \
\"\" Halle				"Sachsen-Anhalt, Halle" \
\"\" Heidelberg			"Baden-Württemberg, Heidelberg" \
\"\" Jena				"Thüringen, Jena" \
\"\" Kaiserslautern		"Rheinland-Pfalz, Kaiserslautern" \
\"\" Kassel				"Hessen, Kassel" \
\"\" Kiel				"Norddeutschland, Kiel" \
\"\" Koeln-Bonn			"NRW, Köln-Bonn" \
\"\" Leipzig			"Sachsen, Leipzig" \
\"\" Luebeck			"Norddeutschland, Lübeck" \
\"\" Muenchen			"Bayern, München" \
\"\" Muensterland		"NRW, Münsterland" \
\"\" Neustadt_adW		"Baden-Württemberg, Neustadt a.d.W" \
\"\" Nuernberg			"Bayern, Nürnberg" \
\"\" Oberlausitz		"Sachsen, Oberlausitz" \
\"\" Ostwestfalen-Lippe	"NRW-Ostwestfalen, Lippe" \
\"\" Rhein-Main-Gebiet	"Hessen, Rhein-Main-Gebiet" \
\"\" Rhein-Neckar1		"Baden-Württemberg, Rhein-Neckar und Vorderpfalz Sender Weinbiet (Neustadt a.d.W)" \
\"\" Rhein-Neckar2		"Baden-Württemberg, Rhein-Neckar und Vorderpfalz Sender Heidelberg" \
\"\" Stuttgart			"Baden-Württemberg, Stuttgart" \
\"\" Westerland			"Norddeutschland, Westerland" \
`

if [ -z "$AUSWAHL" ];then
    zenity --info --title="${TITLE1}" --text="${TEXT2}"
elif [ "$AUSWAHL" = Manuell ];then
    auswahl_manuell
elif [ "$AUSWAHL" ];then
    CONF="$AUSWAHL"
    auswahl
fi

}

function menu_en {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE1}" --text="${TEXT1}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" Manual			"Manual Search (DVB-T/C/S/S2)" \
\"\" Astra          "German FreeTV channel list for DVB-S2" \
`

if [ -z "$AUSWAHL" ];then
    zenity --info --title="${TITLE1}" --text="${TEXT2}"
elif [ "$AUSWAHL" = Manual ];then
    auswahl_manuell
elif [ "$AUSWAHL" ];then
    CONF="$AUSWAHL"
    auswahl
fi

}

###############################################################################

###############################################################################
#Funktion um auf installierten vdr zu prüfen
function vdrisinstalled {

   VDRISINST=`dpkg -s vdr | grep Version:`
   if [ -z "$VDRISINST" ]; then
      zenity --warning --title="${TITLE1}" --text="${TEXT3}"
      exit 1
   fi
	  
}
###############################################################################

###############################################################################
#Funktion für den Start eines manuellen Scans
function auswahl_manuell {

   #prüfen ob vdr installiert ist, wenn nein Skript verlassen
   vdrisinstalled
   #Skript für manuellen Sendersuchlauf holen
   rm -f ~/zbscripts/dvbscan.sh
   wget http://remaster.ztreambox.org/zbscripts/dvbscan.sh -O ~/zbscripts/dvbscan.sh
   #Skript ausführbar machen
   chmod +x ~/zbscripts/dvbscan.sh
   #Skript starten
   cd ~/zbscripts
   ./dvbscan.sh
   exit 1
   
}
###############################################################################

###############################################################################
#Funktion um vorkonfigurierte channels.conf zu installieren
function auswahl {

   (
   #kleine Denkpause
   sleep 2
   #prüfen ob vdr installiert ist, wenn nein Skript verlassen
   vdrisinstalled
   #vdr stoppen
   echo "${TEXT4}" ; sleep 2
   sudo /etc/init.d/vdr stop
   #aktuelle channels.conf sichern
   sudo mv /var/lib/vdr/channels.conf /var/lib/vdr/channels.conf.org
   #ausgewählte Datei für Empfangsregion holen
   echo "${TEXT5}" ; sleep 2 
   sudo wget http://remaster.ztreambox.org/dvb/channels/"$CONF" -O /var/lib/vdr/channels.conf
   #Berechtigungen setzen
   sudo chown vdr:vdr /var/lib/vdr/channels.conf
   #löschen der Epg*.db und TV*.db
   rm -f ~/.xbmc/userdata/Database/Epg*.db
   rm -f ~/.xbmc/userdata/Database/TV*.db
   #vdr starten
   echo "${TEXT6}" ; sleep 2
   sudo /etc/init.d/vdr start
   echo "${TEXT7}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT8}" --pulsate

}
###############################################################################

###############################################################################
#Funktion zur Überprüfung einer Internetverbindung
function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE2}" --text="${TEXT9}"
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
