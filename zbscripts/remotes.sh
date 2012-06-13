#!/bin/bash
###############################################################################
#Skriptname: remotes.sh
#Autor: Holger
#Datum: 05.06.2012
#Funktion:
#Skript zur einfachen Installation von Fernbedienungen
#
#Changelog:
#
#ToDo:
# 
###############################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="Fernbedienung Installation:"
	TITLE2="Internetverbindung:"
	TEXT1="Bitte Fernbedienung auswaehlen:"
	TEXT2="Keine Fernbedienung ausgewaehlt!"
	TEXT3="# LIRC wird gestoppt..."
	TEXT4="# lircd Konfigurationsdateien werden geholt..."
	TEXT5="# xbmc Konfigurationsdateien werden geholt..."
	TEXT6="Keine Hama Fernbedienung gefunden!"
	TEXT7="# Hama Eventclient bereits installiert..."
	TEXT8="# Hama Eventclient wird deinstalliert..."
	TEXT9="# LIRC wird gestartet..."
	TEXT10="# MCE Fernbedienung installiert!"
	TEXT11="MCE Fernbedienung wird installiert..."
	TEXT12="# Digitainer Fernbedienung installiert!"
	TEXT13="Digitainer Fernbedienung wird installiert..."
	TEXT14="# X10 Fernbedienung installiert!"
	TEXT15="X10 Fernbedienung wird installiert..."
	TEXT16="# Paketdateien werden geholt..."
	TEXT17="# Hama Eventclient wird installiert..."
	TEXT18="# Hama Fernbedienung installiert! Rechner wird jetzt neu gestartet!"
	TEXT19="Hama Fernbedienung wird installiert..."
	#TEXT20="# Netbox Eventclient wird installiert..."
	TEXT21="# Netbox Fernbedienung installiert! Rechner wird jetzt neu gestartet!"
	TEXT22="Netbox Fernbedienung wird installiert..."
	TEXT25="# Zotac Fernbedienung installiert! Rechner wird jetzt neu gestartet!"
	TEXT26="Zotac Fernbedienung wird installiert..."
	TEXT23="Installation wurde durch Benutzer abgebrochen!"
	TEXT24="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"
	COLUMN1="PUNKT"
	COLUMN2="BESCHREIBUNG"

else

	TITLE1="Remote installation:"
	TITLE2="Internet connection:"
	TEXT1="Please choose a remote:"
	TEXT2="No remote selected!"
	TEXT3="# stopping LIRC..."
	TEXT4="# getting lircd configuration files..."
	TEXT5="# getting xbmc configuration files..."
	TEXT6="No Hama remote found!"
	TEXT7="# Hama Eventclient already installed..."
	TEXT8="# uninstalling Hama eventclient..."
	TEXT9="# starting LIRC..."
	TEXT10="# MCE remote installed!"
	TEXT11="MCE remote is being installed..."
	TEXT12="# Digitainer remote installed!"
	TEXT13="Digitainer remote is being installed..."
	TEXT14="# X10 remote installed!"
	TEXT15="X10 remote is being installed..."
	TEXT16="# downloading installation package..."
	TEXT17="# Hama eventclient is being installed..."
	TEXT18="# Hama remote installed! Rebooting PC now!"
	TEXT19="Hama remote is being installed..."
	#TEXT20="# Netbox eventclient is being installed..."
	TEXT21="# Netbox remote installed! Rebooting PC now!"
	TEXT22="Netbox is being installed..."
	TEXT25="# Zotac remote installed! Rebooting PC now!"
	TEXT26="Zotac is being installed..."
	TEXT23="Installation canceled by user!"
	TEXT24="No internet connection, installation not possible. Please check your network configuration"
	COLUMN1="ITEM"
	COLUMN2="DESCRIPTION"

fi

###############################################################################
#Systemarchitektur ermitteln (Kurzfassung)
###############################################################################
#ermittelt die Systemarchitektur zur Weiterverarbeitung im Skript
#CPU=`grep " lm " /proc/cpuinfo`
#if [ -z "$CPU" ]; then
CPU=`uname -m`
if [ "$CPU" = "i686" ]; then
   ARCHITECTURE="i386"
else
   ARCHITECTURE="amd64"
fi
###############################################################################

###############################################################################
#Funktion Auswahlmenü
function menu_de {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE1}" --text="${TEXT1}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" MCE					"MCE kompatible Fernbedienung" \
\"\" Hama					"Hama MCE Fernbedienung" \
\"\" Netbox					"FOXCONN Netbox Fernbedienung" \
\"\" Zotac					"Zotac (Philips) Fernbedienung" \
\"\" Digitainer				"X10 (Digitainer) Fernbedienung" \
\"\" X10					"X10 (Pollin) Fernbedienung" \
`

if [ -z "$AUSWAHL" ];then
	zenity --info --text "${TEXT2}"
elif [ "$AUSWAHL" = MCE ];then
	auswahl_mce
elif [ "$AUSWAHL" = Hama ];then
	auswahl_hama
elif [ "$AUSWAHL" = Netbox ];then
	auswahl_netbox
elif [ "$AUSWAHL" = Zotac ];then
	auswahl_zotac
elif [ "$AUSWAHL" = Digitainer ];then
	auswahl_digitainer
elif [ "$AUSWAHL" = X10 ];then
	auswahl_x10
fi

}

function menu_en {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE1}" --text="${TEXT1}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" MCE					"MCE compatible remote" \
\"\" Hama					"Hama MCE remote" \
\"\" Netbox					"FOXCONN Netbox remote" \
\"\" Zotac					"Zotac (Philips) remote" \
\"\" Digitainer				"X10 (Digitainer) remote" \
\"\" X10					"X10 (Pollin) remote" \
`

if [ -z "$AUSWAHL" ];then
	zenity --info --text "${TEXT2}"
elif [ "$AUSWAHL" = MCE ];then
	auswahl_mce
elif [ "$AUSWAHL" = Hama ];then
	auswahl_hama
elif [ "$AUSWAHL" = Netbox ];then
	auswahl_netbox
elif [ "$AUSWAHL" = Zotac ];then
	auswahl_zotac
elif [ "$AUSWAHL" = Digitainer ];then
	auswahl_digitainer
elif [ "$AUSWAHL" = X10 ];then
	auswahl_x10
fi

}
###############################################################################

############################### MCE ###########################################
function auswahl_mce {

   (
   #kurze Denkpause
   sleep 2
   #lird stoppen
   echo "${TEXT3}" ; sleep 2
   sudo /etc/init.d/lirc stop
   #lircd Konfigurationsdateien holen
   echo "${TEXT4}" ; sleep 2  
   sudo mv /etc/lirc/hardware.conf /etc/lirc/hardware.conf.org
   sudo wget http://remaster.ztreambox.org/remotes/mce/hardware.conf.mceusb -O /etc/lirc/hardware.conf
   sudo mv /etc/lirc/lircd.conf /etc/lirc/lircd.conf.org
   sudo wget http://remaster.ztreambox.org/remotes/mce/lircd.conf.mceusb -O /etc/lirc/lircd.conf
   #Eintrag für ati_remote in blacklist.conf auskommentieren, falls vorhanden
   sudo sed -i "s/blacklist ati_remote/#blacklist ati_remote/" /etc/modprobe.d/blacklist.conf
   #XBMC Lircmap.xml
   echo "${TEXT5}" ; sleep 2
   mv ~/.xbmc/userdata/Lircmap.xml ~/.xbmc/userdata/Lircmap.xml.org
   wget http://remaster.ztreambox.org/xbmc/Lircmap.xml -O ~/.xbmc/userdata/Lircmap.xml
   #falls vorhanden, Hama Eventclient deinstallieren
   HUDO=`dpkg -s hudo-hama-eventcli`
   if [ -z "$HUDO" ]; then
	echo "${TEXT6}"
   else
    echo "${TEXT8}" ; sleep 2
	sudo dpkg --purge hudo-hama-eventcli
    sudo rm -f /usr/sbin/hama_mce
    sudo rm -f /etc/udev/rules.d/hama_mce.rules
    sudo rm -f /etc/pm/sleep.d/95_hama_mce        
   fi
   #lircd starten
   echo "${TEXT9}" ; sleep 2
   sudo /etc/init.d/lirc start
   echo "${TEXT10}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT11}" --pulsate

}
###############################################################################

############################### Hama #############################
function auswahl_hama {

   (
   #kurze Denkpause
   sleep 2
   #XBMC Konfigurationsdateien holen
   echo "${TEXT5}" ; sleep 2
   #Lircmap.xml wird für Eventclient nicht benötigt
   mv ~/.xbmc/userdata/Lircmap.xml ~/.xbmc/userdata/Lircmap.xml.org
   #Paket holen
   echo "${TEXT16}" ; sleep 2
   cd ~
   wget http://remaster.ztreambox.org/remotes/hama/hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
   #Paket installieren
   HUDO=`dpkg -s hudo-hama-eventcli`
	if [ -z "$HUDO" ]; then
		echo "${TEXT17}" ; sleep 2
		sudo dpkg -i hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
		#Namensänderung wegen Reihenfolge Suspend Hooks
		sudo mv /etc/pm/sleep.d/99_hama_mce /etc/pm/sleep.d/95_hama_mce
		sudo chmod +x /etc/pm/sleep.d/95_hama_mce
		sudo rm -f ~/.xbmc/userdata/keymaps/hama_mce.xml
	else
		echo "${TEXT7}"
	fi
	#passende hama_mce.rules holen
	sudo rm -f /etc/udev/rules.d/hama_mce.rules
	sudo wget http://remaster.ztreambox.org/remotes/hama/hama_mce.rules.hama -O /etc/udev/rules.d/hama_mce.rules
	#heruntergeladenes Paket löschen
   rm -f hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
   echo "${TEXT18}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT19}" --pulsate
   #
   if [ "$?" = 1 ]; then
      zenity --warning --title="${TITLE1}" --text="${TEXT23}"
   else
      sudo reboot
   fi

}
###############################################################################

############################### Netbox #############################
function auswahl_netbox {

   (
   #kurze Denkpause
   sleep 2
   #XBMC Konfigurationsdateien holen
   echo "${TEXT5}" ; sleep 2
   #Lircmap.xml wird für Eventclient nicht benötigt
   mv ~/.xbmc/userdata/Lircmap.xml ~/.xbmc/userdata/Lircmap.xml.org
   #Paket holen
   echo "${TEXT16}" ; sleep 2
   cd ~
   wget http://remaster.ztreambox.org/remotes/hama/hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
   #Paket installieren
   HUDO=`dpkg -s hudo-hama-eventcli`
	if [ -z "$HUDO" ]; then
		echo "${TEXT17}" ; sleep 2
		sudo dpkg -i hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
		#Namensänderung wegen Reihenfolge Suspend Hooks
		sudo mv /etc/pm/sleep.d/99_hama_mce /etc/pm/sleep.d/95_hama_mce
		sudo chmod +x /etc/pm/sleep.d/95_hama_mce
		sudo rm -f ~/.xbmc/userdata/keymaps/hama_mce.xml
	else
		echo "${TEXT7}"
	fi
	#passende hama_mce.rules holen
	sudo rm -f /etc/udev/rules.d/hama_mce.rules
	sudo wget http://remaster.ztreambox.org/remotes/foxconn/hama_mce.rules.foxconn -O /etc/udev/rules.d/hama_mce.rules
	#heruntergeladenes Paket löschen
   rm -f hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
   echo "${TEXT21}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT22}" --pulsate
   #
   if [ "$?" = 1 ]; then
      zenity --warning --title="${TITLE1}" --text="${TEXT23}"
   else
      sudo reboot
   fi

}
###############################################################################

############################### Netbox ########################################
function auswahl_zotac {

   (
   #kurze Denkpause
   sleep 2
   #XBMC Konfigurationsdateien holen
   echo "${TEXT5}" ; sleep 2
   #Lircmap.xml wird für Eventclient nicht benötigt
   mv ~/.xbmc/userdata/Lircmap.xml ~/.xbmc/userdata/Lircmap.xml.org
   #Paket holen
   echo "${TEXT16}" ; sleep 2
   cd ~
   wget http://remaster.ztreambox.org/remotes/hama/hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
   #Paket installieren
   HUDO=`dpkg -s hudo-hama-eventcli`
	if [ -z "$HUDO" ]; then
		echo "${TEXT17}" ; sleep 2
		sudo dpkg -i hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
		#Namensänderung wegen Reihenfolge Suspend Hooks
		sudo mv /etc/pm/sleep.d/99_hama_mce /etc/pm/sleep.d/95_hama_mce
		sudo chmod +x /etc/pm/sleep.d/95_hama_mce
		sudo rm -f ~/.xbmc/userdata/keymaps/hama_mce.xml
	else
		echo "${TEXT7}"
	fi
	#passende hama_mce.rules holen
	sudo rm -f /etc/udev/rules.d/hama_mce.rules
	sudo wget http://remaster.ztreambox.org/remotes/zotac/hama_mce.rules.zotac -O /etc/udev/rules.d/hama_mce.rules
	#heruntergeladenes Paket löschen
   rm -f hudo-hama-eventcli_1.5-1_${ARCHITECTURE}.deb
   echo "${TEXT25}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT26}" --pulsate
   #
   if [ "$?" = 1 ]; then
      zenity --warning --title="${TITLE1}" --text="${TEXT23}"
   else
      sudo reboot
   fi

}
###############################################################################

############################### Medion Digitainer #############################
function auswahl_digitainer {

   (
   #kurze Denkpause
   sleep 2
   #lird stoppen
   echo "${TEXT3}" ; sleep 2   
   sudo /etc/init.d/lirc stop
   #lird Konfigurationsdateien holen
   echo "${TEXT4}" ; sleep 2  
   sudo mv /etc/lirc/lircd.conf /etc/lirc/lircd.conf.org
   sudo wget http://remaster.ztreambox.org/remotes/digitainer/lircd.conf -O /etc/lirc/lircd.conf
   #XBMC Konfigurationsdateien holen
   echo "${TEXT5}" ; sleep 2 
   mv ~/.xbmc/userdata/Lircmap.xml ~/.xbmc/userdata/Lircmap.xml.org
   wget http://remaster.ztreambox.org/remotes/digitainer/Lircmap.xml -O ~/.xbmc/userdata/Lircmap.xml
   #falls vorhanden, Hama Eventclient deinstallieren
   HUDO=`dpkg -s hudo-hama-eventcli`
   if [ -z "$HUDO" ]; then
	echo "${TEXT6}"
   else
    echo "${TEXT8}" ; sleep 2
	sudo dpkg --purge hudo-hama-eventcli
    sudo rm -f /usr/sbin/hama_mce
    sudo rm -f /etc/udev/rules.d/hama_mce.rules
    sudo rm -f /etc/pm/sleep.d/95_hama_mce        
   fi
   #lircd starten
   echo "${TEXT9}" ; sleep 2
   sudo /etc/init.d/lirc start
   echo "${TEXT12}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT13}" --pulsate

}
###############################################################################

############################### X10 ###########################################
function auswahl_x10 {

   (
   #kurze Denkpause
   sleep 2
   #lird stoppen
   echo "${TEXT3}" ; sleep 2
   sudo /etc/init.d/lirc stop
   #lird Konfigurationsdateien holen
   echo "${TEXT4}" ; sleep 2
   sudo mv /etc/lirc/hardware.conf /etc/lirc/hardware.conf.org
   sudo wget http://remaster.ztreambox.org/remotes/x10/hardware.conf.x10 -O /etc/lirc/hardware.conf
   sudo mv /etc/lirc/lircd.conf /etc/lirc/lircd.conf.org
   sudo wget http://remaster.ztreambox.org/remotes/x10/lircd.conf.x10 -O /etc/lirc/lircd.conf
   #blacklist.conf konfigurieren
   ISCONFED=`grep ati_remote /etc/modprobe.d/blacklist.conf`
   if [ -z "$ISCONFED" ]; then
	#Eintrag für ati_remote in blacklist.conf eintragen
	sudo sed -i "5i\blacklist ati_remote" /etc/modprobe.d/blacklist.conf
   else
	#Eintrag für ati_remote in blacklist.conf einkommentieren
	sudo sed -i "s/#blacklist ati_remote/blacklist ati_remote/" /etc/modprobe.d/blacklist.conf
   fi
   #XBMC Konfigurationsdateien holen
   echo "${TEXT5}" ; sleep 2 
   mv ~/.xbmc/userdata/Lircmap.xml ~/.xbmc/userdata/Lircmap.xml.org
   wget http://remaster.ztreambox.org/remotes/x10/Lircmap.xml.x10 -O ~/.xbmc/userdata/Lircmap.xml
   #falls vorhanden, Hama Eventclient deinstallieren
   HUDO=`dpkg -s hudo-hama-eventcli`
   if [ -z "$HUDO" ]; then
	echo "${TEXT6}"
   else
    echo "${TEXT8}" ; sleep 2
	sudo dpkg --purge hudo-hama-eventcli
    sudo rm -f /usr/sbin/hama_mce
    sudo rm -f /etc/udev/rules.d/hama_mce.rules
    sudo rm -f /etc/pm/sleep.d/95_hama_mce        
   fi
   #lircd starten
   echo "${TEXT9}" ; sleep 2
   sudo /etc/init.d/lirc start
   echo "${TEXT14}"
   ) | zenity --progress --title="${TITLE1}" --text="${TEXT15}" --pulsate

}
###############################################################################

###############################################################################
#Funktion zur Überprüfung einer Internetverbindung
function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE2}" --text="${TEXT24}"
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
