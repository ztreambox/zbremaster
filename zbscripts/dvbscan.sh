#!/bin/bash
#######################################################################
#Skriptname: dvbscan.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Skript zum manuellen Scannen von TV-Kanälen
#
#Changelog:
#
#ToDo:
# - 
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="DVB Hardware:"
	TITLE2="DVB Kanalsuche:"
	TITLE3="DVB-T:"
	TITLE4="DVB-C:"
	TITLE5="Auswahl Satellit:"
	TITLE6="DVB-S/S2:"
	TEXT1="Keine DVB Hardware gefunden!? Bitte zuerst einen Treiber installieren oder den Rechner neu starten!"
	TEXT2="Frontend Typ auswaehlen"
	TEXT3="Kein Frontend Typ ausgewaehlt!"
	TEXT4="# VDR wird gestoppt..."
	TEXT5="# Kanalsuche wird durchgefuehrt...Bitte warten...Kann bis zu 10 Min. dauern!"
	TEXT6="# Kanalsuche war nicht erfolgreich!"
	TEXT7="# channels.conf wird aktualisiert..."
	TEXT8="# VDR wird gestartet..."
	TEXT9="# Kanalsuche beendet und Kanalliste aktualisiert!"
	TEXT10="Kanalsuche wird gestartet..."
	TEXT11="# Kanalsuche wird durchgefuehrt...Bitte warten...Kann bis zu 30 Min. dauern!"
	TEXT12="Satellit auswaehlen"
	TEXT13="Kein Satellit ausgewaehlt!"
	TEXT14="# Kanalsuche wird durchgefuehrt...Bitte warten...Kann bis zu 50 Min. dauern!"
	COLUMN1="PUNKT"
	COLUMN2="BESCHREIBUNG"

else

	TITLE1="DVB hardware:"
	TITLE2="DVB channel search:"
	TITLE3="DVB-T:"
	TITLE4="DVB-C:"
	TITLE5="Satellite selection:"
	TITLE6="DVB-S/S2:"
	TEXT1="No DVB hardware found!? First install a driver or reboot your PC!"
	TEXT2="Choose a frontend type"
	TEXT3="No frontend type choosen!"
	TEXT4="# stopping VDR..."
	TEXT5="# Channel search is carried out...please wait...Can take up to 10 minutes!"
	TEXT6="# Channel search was not successful!"
	TEXT7="# channels.conf is updated..."
	TEXT8="# starting VDR..."
	TEXT9="# Channel search stopped and channel list updated!"
	TEXT10="Channel search started..."
	TEXT11="# Channel search is carried out...please wait...Can take up to 30 minutes!"
	TEXT12="Choose satellite"
	TEXT13="No satellite choosen!"
	TEXT14="# Channel search is carried out...please wait...Can take up to 50 minutes!"
	COLUMN1="ITEM"
	COLUMN2="DESCRIPTION"

fi

function detect {

    #DVBDETECT=`dmesg | grep DVB`
	DEVDVB=`ls -l /dev/dvb/adapter0`
    if [ -z "$DEVDVB" ]; then
       zenity --warning --title="${TITLE1}" --text="${TEXT1}"
       exit 1
    else
       if [ "$LANGCONF" = "de_DE.UTF-8" ]; then
		frontend_de
	   else
		frontend_en
	   fi
    fi   

}

function frontend_de {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE2}" --text="${TEXT2}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" T			"Terrestrich (DVB-T)" \
\"\" C			"Kabel (DVB-C)" \
\"\" S			"Satellit (DVB-S/S2)" \
`

if [ -z "$AUSWAHL" ];then
	zenity --info --title="${TITLE2}" --text="${TEXT3}"
elif [ "$AUSWAHL" = "T" ];then
	FRONTEND="t"
	auswahl_t
elif [ "$AUSWAHL" = "C" ];then
	FRONTEND="c"
	auswahl_c
elif [ "$AUSWAHL" = "S" ];then
	FRONTEND="s"
	auswahl_s
fi

}

function frontend_en {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE2}" --text="${TEXT2}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" T			"Terrestial (DVB-T)" \
\"\" C			"Cabel (DVB-C)" \
\"\" S			"Satellite (DVB-S/S2)" \
`

if [ -z "$AUSWAHL" ];then
	zenity --info --title="${TITLE2}" --text="${TEXT3}"
elif [ "$AUSWAHL" = "T" ];then
	FRONTEND="t"
	auswahl_t
elif [ "$AUSWAHL" = "C" ];then
	FRONTEND="c"
	auswahl_c
elif [ "$AUSWAHL" = "S" ];then
	FRONTEND="s"
	auswahl_s
fi

}

function auswahl_t {

   (
   #kleine Denkpause
   sleep 2
   cd ~
   #vdr stoppen
   echo "${TEXT4}" ; sleep 2
   sudo /etc/init.d/vdr stop
   #Kanalsuche
   echo "${TEXT5}"
   rm -f channels.conf.dvbt
   w_scan -f$FRONTEND -A1 -cDE -o7 >> channels.conf.dvbt
   if [ "$?" = 1 -o "$?" = -1 ]; then
      echo "${TEXT6}"
	  rm -f channels.conf.dvbt
   else
      echo "${TEXT7}"; sleep 2
	  sudo mv /var/lib/vdr/channels.conf /var/lib/vdr/channels.conf.org
      sudo cp ~/channels.conf.dvbt /var/lib/vdr/channels.conf
      rm -f ~/channels.conf.dvbt
      echo "${TEXT8}" ; sleep 2
	  sudo /etc/init.d/vdr start
	  #löschen der Epg*.db und TV*.db
	  rm -f ~/.xbmc/userdata/Database/Epg*.db
	  rm -f ~/.xbmc/userdata/Database/TV*.db
	  echo "${TEXT9}"
   fi
   ) | zenity --progress --title="${TITLE3}" --text="${TEXT10}" --pulsate
   
}

function auswahl_c {

   (
   #kleine Denkpause
   sleep 2
   cd ~
   #vdr stoppen
   echo "${TEXT4}" ; sleep 2
   sudo /etc/init.d/vdr stop
   #Kanalsuche
   echo "${TEXT10}"
   rm -f channels.conf.dvbc
   w_scan -f$FRONTEND -A2 -cDE -o7 >> channels.conf.dvbc
   if [ "$?" = 1 -o "$?" = -1 ]; then
      echo "${TEXT6}"
	  rm -f channels.conf.dvbc
   else
      echo "${TEXT7}"; sleep 2
	  sudo mv /var/lib/vdr/channels.conf /var/lib/vdr/channels.conf.org
      sudo cp ~/channels.conf.dvbc /var/lib/vdr/channels.conf
      rm -f ~/channels.conf.dvbc
      echo "${TEXT8}" ; sleep 2
	  sudo /etc/init.d/vdr start
	  #löschen der Epg*.db und TV*.db
	  rm -f ~/.xbmc/userdata/Database/Epg*.db
	  rm -f ~/.xbmc/userdata/Database/TV*.db
	  echo "${TEXT9}"
   fi
   ) | zenity --progress --title="${TITLE4}" --text="${TEXT10}" --pulsate
   
}

function auswahl_s {

   #Auswahl Satellit
   AUSWAHLSAT=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE5}" --text="${TEXT12}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
   \"\" S19E2			"19.2 east Astra 1F/1G/1H/1KR/1L" \
   \"\" S23E5          "23.5 east Astra 1E/3A" \
   \"\" S28E2			"28.2 east Astra 2A/2B/2C/2D" \
   \"\" S31E5			"31.5 east Astra 5A/1D" \
   \"\" S4E8			"4.8 east Sirius" \
   \"\" S7E0			"7.0 east Eutelsat W3A" \
   \"\" S9E0			"9.0 east Eurobird 9" \
   \"\" S10E0			"10.0 east Eutelsat W1" \
   \"\" S13E0			"13.0 east Hotbird 6/7A/8" \
   \"\" S16E0			"16.0 east Eutelsat W2" \
   \"\" S21E6			"21.6 east Eutelsat W6" \
   \"\" S25E5			"25.5 east Eurobird 2" \
   \"\" S26EX			"26.X east Badr C/3/4/6" \
   \"\" S28E5			"28.5 east EuroBird 1" \
   \"\" S32E9			"32.9 east Intelsat 802" \
   \"\" S33E0			"33.0 east Eurobird 3" \
   \"\" S35E9			"35.9 east Eutelsat W4" \
   \"\" S36E0			"36.0 east Eutelsat Sesat" \
   \"\" S38E0			"38.0 east Paksat 1" \
   \"\" S39E0			"39.0 east Hellas Sat 2" \
   \"\" S40EX			"40.X east Express AM1" \
   \"\" S41E9			"41.9 east Turksat 2A/3A" \
   \"\" S45E0			"45.0 east Intelsat 12" \
   \"\" S49E0			"49.0 east Yamal 202" \
   \"\" S53E0			"53.0 east Express AM22" \
   \"\" S57E0			"57.0 east Bonum 1" \
   \"\" S57EX			"57.X east NSS 703" \
   \"\" S60EX			"60.X east Intelsat 904" \
   \"\" S62EX			"62.X east Intelsat 902" \
   \"\" S64E2			"64.2 east Intelsat 906" \
   \"\" S68EX			"68.X east Intelsat 7/10" \
   \"\" S70E5			"70.5 east Eutelsat W5" \
   \"\" S72EX			"72.X east Intelsat 4" \
   \"\" S75EX			"75.X east ABS 1" \
   \"\" S76EX			"76.X east Telstar 10" \
   \"\" S78E5			"78.5 east Thaicom 2/5" \
   \"\" S80EX			"80.X east Express AM2" \
   \"\" S83EX			"83.X east Insat 2E/3B/4A" \
   \"\" S87E5			"87.5 east ChinaStar 1" \
   \"\" S88EX			"88.X east ST 1" \
   \"\" S90EX			"90.X east Yamal 201" \
   \"\" S91E5			"91.5 east Measat 3" \
   \"\" S93E5			"93.5 east Insat 3A/4B" \
   \"\" S95E0			"95.0 east NSS 6" \
   \"\" S96EX			"96.X east Express AM33" \
   \"\" S100EX			"100.X east AsiaSat 2" \
   \"\" S105EX			"105.X east AsiaSat 3S" \
   \"\" S108EX			"108.X east Telkom 1 & NSS 11" \
   \"\" S140EX			"140.X east Express AM3" \
   \"\" S160E0			"160.0 east Optus D1" \
   \"\" S0W8			"0.8 west Thor 3/5 & Intelsat 10-02" \
   \"\" S4W0			"4.0 west Amos 1/2/3" \
   \"\" S5WX			"5.X west Atlantic Bird 3" \
   \"\" S7W0			"7.0 west Nilesat 101/102 & Atlantic Bird 4" \
   \"\" S8W0			"8.0 west Atlantic Bird 2" \
   \"\" S11WX			"11.X west Express A3" \
   \"\" S12W5			"12.5 west Atlantic Bird 1" \
   \"\" S14W0			"14.0 west Express A4" \
   \"\" S15W0			"15.0 west Telstar 12" \
   \"\" S18WX			"18.X west Intelsat 901" \
   \"\" S22WX			"22.X west NSS 7" \
   \"\" S24WX			"24.X west Intelsat 905" \
   \"\" S27WX			"27.X west Intelsat 907" \
   \"\" S30W0			"30.0 west Hispasat 1C/1D" \
   `

   if [ -z "$AUSWAHLSAT" ];then
      zenity --info --title="${TITLE5}" --text="${TEXT13}"
   elif [ "$AUSWAHLSAT" ];then
      SAT="$AUSWAHLSAT"
      auswahl_sat
   fi

}

function auswahl_sat {

   (
   #kleine Denkpause
   sleep 2
   cd ~
   #vdr stoppen
   echo "${TEXT4}" ; sleep 2
   sudo /etc/init.d/vdr stop
   #Kanalsuche
   echo "${TEXT10}"
   rm -f channels.conf.dvbs
   w_scan -fs -s$SAT -o7 >> channels.conf.dvbs
   if [ "$?" = 1 -o "$?" = -1 ]; then
      echo "${TEXT6}"
	  rm -f channels.conf.dvbs
   else
      echo "${TEXT7}"; sleep 2
	  sudo mv /var/lib/vdr/channels.conf /var/lib/vdr/channels.conf.org
      sudo cp ~/channels.conf.dvbs /var/lib/vdr/channels.conf
      rm -f ~/channels.conf.dvbs
      echo "${TEXT8}" ; sleep 2
	  sudo /etc/init.d/vdr start
	  #löschen der Epg*.db und TV*.db
	  rm -f ~/.xbmc/userdata/Database/Epg*.db
	  rm -f ~/.xbmc/userdata/Database/TV*.db
	  echo "${TEXT9}"
   fi
   ) | zenity --progress --title="${TITLE6}" --text="${TEXT10}" --pulsate

}

#Aufruf der Funktion detect
detect
