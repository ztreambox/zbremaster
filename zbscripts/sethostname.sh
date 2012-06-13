#!/bin/sh
#######################################################################
#Skriptname: sethostname.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Skript zum Setzen des Rechner- und Arbeitsgruppennamens
#Changelog:
#
#ToDo:
# 
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="Rechnername:"
	TITLE2="Arbeitsgruppen-Name:"
	TITLE3="Netzwerknamen anpassen:"
	TEXT1="Bitte Rechnernamen eingeben"
	TEXT2="Bitte Arbeitsgruppenamen in GROSSBUCHSTABEN eingeben"
	TEXT3="Rechnername wurde nicht geaendert!"
	TEXT4="Arbeitsgruppename wurde nicht geaendert!"
	TEXT5="# Rechnername wurde angepasst!"
	TEXT6="Rechnername wird angepasst..."
	TEXT7="# Arbeitsgruppenname wurde angepasst! Bitte Rechner neu starten!"
	TEXT8="Arbeitsgruppenname wird angepasst..."
	TEXT9="# Samba wird angehalten..."
	TEXT10="# Konfigurationsdateien werden angepasst..."
	TEXT11="# Samba wird gestartet..."
	TEXT12="Anpassung wurde durch Benutzer abgebrochen!"

else

	TITLE1="Computer name:"
	TITLE2="Workgroup name:"
	TITLE3="Modifying network names:"
	TEXT1="Please input computer name"
	TEXT2="Please input workgroup name in UPPER cases"
	TEXT3="Computer name not changed!"
	TEXT4="Workgroup name not changed!"
	TEXT5="# Computer name changed!"
	TEXT6="Modifying computer name..."
	TEXT7="# Workgroup name changed! Please reboot PC!"
	TEXT8="Workgroup name is being changed..."
	TEXT9="# stopping samba..."
	TEXT10="# Modifying configuration files..."
	TEXT11="# starting samba..."
	TEXT12="Modification canceled by user!"

fi

#aktuellen Rechnernamen ermitteln
ACTHOSTNAME=`hostname`
#Eingabedialog anzeigen
NEWHOSTNAME=`zenity --entry --title="${TITLE1}" --text="${TEXT1}" --entry-text="$ACTHOSTNAME"`
#wenn kein anderer Name eingegeben wurde oder leer
if [ "$NEWHOSTNAME" = "$ACTHOSTNAME" -o -z "$NEWHOSTNAME" ];then
	zenity --info --title="${TITLE1}" --text "${TEXT3}"
	#exit 1
else
	(
	#Kurze Denkpause
    sleep 2
    #Rechnernamen in Datei hostname setzen
	sudo sed -i "s/$ACTHOSTNAME/$NEWHOSTNAME/" /etc/hostname ; sleep 2
    #Rechnernamen in Datei hosts setzen
	sudo sed -i "s/$ACTHOSTNAME/$NEWHOSTNAME/" /etc/hosts ; sleep 2
	echo "${TEXT5}"
	) | zenity --progress --title="${TITLE1}" --text="${TEXT6}" --pulsate
fi

#aktuellen Arbeitsgruppennamen ermitteln
ACTWORKGROUP=`cat /etc/samba/smb.conf | grep "workgroup =" | awk -F'= ' '{ print $2 }'`
#Eingabedialog anzeigen
WORKGROUP=`zenity --entry --title="${TITLE2}" --text="${TEXT2}" --entry-text="$ACTWORKGROUP"`
#wenn kein anderer Name eingegeben wurde oder leer
if [ "$WORKGROUP" = "$ACTWORKGROUP" -o -z "$WORKGROUP" ];then
	zenity --info --title="${TITLE2}" --text "${TEXT4}"
	exit 1
else
	(
	#Kurze Denkpause
    sleep 2
	#samba Dienst stoppen
	echo "${TEXT9}" ; sleep 2
	sudo service smbd stop
	#samba Konfigurationsdataei anpassen
	echo "${TEXT10}" ; sleep 2
	sudo sed -i "s/= $ACTWORKGROUP/= $WORKGROUP/" /etc/samba/smb.conf
	#xbmc Konfigurationsdatei anpassen
	sudo sed -i "s/>$ACTWORKGROUP</>$WORKGROUP</" ~/.xbmc/userdata/guisettings.xml
	#samba Dienst starten
	echo "${TEXT11}" ; sleep 2
	sudo service smbd start
	echo "${TEXT7}"
	) | zenity --progress --title="${TITLE2}" --text="${TEXT8}" --pulsate
fi

if [ "$?" = 1 ]; then
	zenity --warning --title="${TITLE3}" --text="${TEXT12}"
fi 