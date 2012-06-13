#!/bin/bash
#######################################################################
#Skriptname: ssh_new.sh
#Autor: Holger
#Datum: 25.05.2012
#Funktion:
#Skript zur Erneuerung der ssh Host-Keys
#
#Changelog:
#
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="SSH-Keys:"
	TEXT1="Neue SSH Host-Keys werden erstellt..."
	TEXT2="# ssh wird gestoppt..."
	TEXT3="# ssh Host-Keys werden erstellt..."
	TEXT4="# ssh wird gestartet..."
	TEXT5="# Neue SSH Host-Keys wurden erstellt!"

else

	TITLE1="SSH-Keys:"
	TEXT1="Creating new SSH Host-Keys..."
	TEXT2="# stopping ssh..."
	TEXT3="# creating new ssh Host-Keys..."
	TEXT4="# starting ssh..."
	TEXT5="# New SSH Host-Keys created!"

fi

(
sleep 2
echo "${TEXT2}" ; sleep 2
sudo /etc/init.d/ssh stop
echo "${TEXT3}" ; sleep 2
printf "y\\n"|sudo ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
printf "y\\n"|sudo ssh-keygen -t dsa -N "" -f /etc/ssh/ssh_host_dsa_key
echo "${TEXT4}" ; sleep 2
sudo /etc/init.d/ssh start
echo "${TEXT5}"
) | zenity --progress --title="${TITLE1}" --text="${TEXT1}" --pulsate