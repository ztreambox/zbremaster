#!/bin/bash
#######################################################################
#Skriptname:xbmc-skins.sh
#Autor: Holger
#Datum: 04.06.2012
#Funktion:
#Skript um weitere Skins für XBMC bereitzustellen
#
#Comparison of skin features:
#http://wiki.xbmc.org/index.php?title=Comparison_of_skin_features#cite_note-live-0
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

	TITLE1="XBMC-Skin:"
	TITLE2="Internetverbindung:"
	TEXT1="Ausgewaehlte XBMC Skin installieren"
	TEXT2="Keine XBMC Skin ausgewaehlt!"
	TEXT3="Transparency Skin ist bereits installiert! Deinstallieren?"
	TEXT4="Aeon Skin ist bereits installiert! Deinstallieren?"
	TEXT5="Cirrus Extended Skin ist bereits installiert! Deinstallieren?"
	TEXT6="Soll Transparency Skin installiert werden?"
	TEXT7="Soll Aeon Skin installiert werden?"
	TEXT8="Soll Cirrus Extended Skin installiert werden?"
	TEXT9="# Paketquellen aktualisieren..."
	TEXT10="# subversion installieren..."
	TEXT11="# Transparency Skin installieren..."
	TEXT12="# Transparency Skin installiert!..."
	TEXT13="Transparency Skin wird installiert..Bitte warten..."
	TEXT14="Aktion abgebrochen!"
	TEXT15="# Aeon Skin installieren..."
	TEXT16="# Aeon Skin installiert!..."
	TEXT17="Aeon Skin wird installiert..Bitte warten..."
	TEXT18="# Cirrus Extended Skin installieren..."
	TEXT19="# Cirrus Extended Skin installiert!..."
	TEXT20="Cirrus Extended Skin wird installiert..Bitte warten..."
	TEXT21="# Transparency Skin wird deinstalliert..."
	TEXT22="# subversion wird deinstalliert..."
	TEXT23="# Transparency Skin deinstalliert!"
	TEXT24="Transparency Skin wird deinstalliert..Bitte warten..."
	TEXT25="# Aeon Skin wird deinstalliert..."
	TEXT26="# Aeon Skin deinstalliert!"
	TEXT27="Aeon Skin wird deinstalliert..Bitte warten..."
	TEXT28="# Cirrus Extended Skin wird deinstalliert..."
	TEXT29="# Cirrus Extended Skin deinstalliert!"
	TEXT30="Cirrus Extended Skin wird deinstalliert..Bitte warten..."
	TEXT31="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"
	COLUMN1="PUNKT"
	COLUMN2="BESCHREIBUNG"

else

	TITLE1="XBMC-Skin:"
	TITLE2="Internet connection:"
	TEXT1="Choose a XBMC Skin to install"
	TEXT2="No XBMC Skin choosen!"
	TEXT3="Transparency Skin already installed! Uninstall?"
	TEXT4="Aeon Skin already installed! Uninstall?"
	TEXT5="Cirrus Extended Skin already installed! Uninstall?"
	TEXT6="Should Transparency Skin be installed?"
	TEXT7="Should Aeon Skin be installed?"
	TEXT8="Should Cirrus Extended Skin be installed?"
	TEXT9="# updating package sources..."
	TEXT10="# installing subversion..."
	TEXT11="# installing Transparency Skin..."
	TEXT12="# Transparency Skin installed!..."
	TEXT13="Transparency Skin is being installed..please wait..."
	TEXT14="Action canceled!"
	TEXT15="# installing Aeon Skin..."
	TEXT16="# Aeon Skin installed!..."
	TEXT17="Aeon Skin is being installed..please wait..."
	TEXT18="# installing Cirrus Extended Skin..."
	TEXT19="# Cirrus Extended Skin installed!..."
	TEXT20="Cirrus Extended Skin is being installed..please wait..."
	TEXT21="# Transparency Skin is being uninstalled..."
	TEXT22="# uninstalling subversion..."
	TEXT23="# Transparency Skin uninstalled!"
	TEXT24="Uninstalling Transparency Skin..please wait..."
	TEXT25="# Aeon Skin is being uninstalled..."
	TEXT26="# Aeon Skin uninstalled!"
	TEXT27="Uninstalling Aeon Skin..please wait..."
	TEXT28="# Cirrus Extended Skin is being uninstalled..."
	TEXT29="# Cirrus Extended Skin uninstalled!"
	TEXT30="Cirrus Extended Skin is being uninstalled..please wait..."
	TEXT31="No internet connection, installation not possible. Please check your network configuration"
	COLUMN1="ITEM"
	COLUMN2="DESCRIPTION"

fi

###############################################################################
#Auswahlmenü
function menu {

AUSWAHL=`zenity --list --radiolist --width=700 --height=350 --title="${TITLE1}" --text="${TEXT1}" --column="" --column ${COLUMN1} --column ${COLUMN2} \
\"\" Transparency	"Transparency Skin" \
\"\" Aeon			"Aeon MQ3 Skin" \
\"\" Cirrus			"Cirrus Extended Skin" \
`

if [ -z "$AUSWAHL" ];then
	zenity --info --title="${TITLE1}" --text="${TEXT2}"
elif [ "$AUSWAHL" = Transparency ];then
	detecttransparency
elif [ "$AUSWAHL" = Aeon ];then
	detectaeon
elif [ "$AUSWAHL" = Cirrus ];then
	detectcirrus
fi

}
###############################################################################

###############################################################################
#Funktion zur Erkennung ob Transparency Skin installiert ist
function detecttransparency {

   #Prüfen ob Tranparency Skin installiert ist
   if [ -d "/usr/share/xbmc/addons/skin.transparency" ]; then
      zenity --question --title="${TITLE1}" --text="${TEXT3}"
	  if [ "$?" = 0 ]; then
	     deinsttransparency
      else
	     exit 1
	  fi
   else
      insttransparency
   fi

}
###############################################################################

###############################################################################
#Funktion zur Erkennung ob Aeon Skin installiert ist
function detectaeon {

   #Prüfen ob Aeon Skin installiert ist
   if [ -d "/usr/share/xbmc/addons/skin.aeonmq.3" ]; then
      zenity --question --title="${TITLE1}" --text="${TEXT4}"
	  if [ "$?" = 0 ]; then
	     deinstaeon
      else
	     exit 1
	  fi
   else
      instaeon
   fi

}
###############################################################################

###############################################################################
#Funktion zur Erkennung ob Cirrus Skin installiert ist
function detectcirrus {

   #Prüfen ob Cirrus Skin installiert ist
   if [ -d "/usr/share/xbmc/addons/skin.cirrus.extended.v2" ]; then
      zenity --question --title="${TITLE1}" --text="${TEXT5}"
	  if [ "$?" = 0 ]; then
	     deinstcirrus
      else
	     exit 1
	  fi
   else
      instcirrus
   fi

}
###############################################################################

###############################################################################
#Funktion zur Installation der Transparency Skin
function insttransparency {

   zenity --question --title="${TITLE1}" --text="${TEXT6}"

   if [ "$?" = 0 ]; then

      (
      sleep 2
      echo "${TEXT9}" ; sleep 2
      sudo apt-get update -y --force-yes
      echo "${TEXT10}" ; sleep 2
      sudo apt-get -y --force-yes install subversion
      cd /usr/share/xbmc/addons
      #Dateien holen
      echo "${TEXT11}" ; sleep 2
      sudo svn checkout http://transparency-xbmc.googlecode.com/svn/trunk/ skin.transparency
      echo "${TEXT12}"
      ) | zenity --progress --title="${TITLE1}" --text="${TEXT13}" --pulsate

else

     #Abbrechen
     zenity --info --title="${TITLE1}" --text "${TEXT14}"
     exit 1

fi

}
###############################################################################

###############################################################################
#Funktion zur Installation der Aeon Skin
#http://mod-skin.googlecode.com/svn/trunk/skin.aeonmq.3/
function instaeon {

   zenity --question --title="${TITLE1}" --text="${TEXT7}"

   if [ "$?" = 0 ]; then

      (
      echo "${TEXT9}" ; sleep 2
      sudo apt-get update -y --force-yes
      echo "${TEXT10}" ; sleep 2
      sudo apt-get -y --force-yes install subversion
      #Dateien installieren
      echo "${TEXT15}" ; sleep 2
      #cd /usr/share/xbmc/addons
      cd ~
      svn checkout http://mod-skin.googlecode.com/svn/trunk/skin.aeonmq.3/
      sudo mv ~/skin.aeonmq.3/skin.aeon*.zip /usr/share/xbmc/addons
      cd /usr/share/xbmc/addons/
      sudo unzip -o skin.aeon*.zip
      sudo rm -f skin.aeon*.zip
      cd ~
      sudo rm -rf skin.aeonmq.3
      echo "${TEXT16}"
      ) | zenity --progress --title="${TITLE1}" --text="${TEXT17}" --pulsate

else

     #Abbrechen
     zenity --info --title="${TITLE1}" --text "${TEXT14}"
     exit 1

fi

}
###############################################################################

###############################################################################
#Funktion zur Installation der Cirrus Extended
function instcirrus {

   zenity --question --title="${TITLE1}" --text="${TEXT8}"

   if [ "$?" = 0 ]; then

      (
      sleep 2
	  echo "${TEXT9}" ; sleep 2
      sudo apt-get update -y --force-yes
      echo "${TEXT10}" ; sleep 2
      sudo apt-get -y --force-yes install subversion
      cd /usr/share/xbmc/addons
      #Dateien holen
      echo "${TEXT18}" ; sleep 2
      sudo svn checkout https://repository-butchabay.googlecode.com/svn/branches/eden
      sudo mv ./eden/skin.cirrus.extended.v2 .
	  sudo rm -rf eden
      echo "${TEXT19}"
      ) | zenity --progress --title="${TITLE1}" --text="${TEXT20}" --pulsate

else

     #Abbrechen
     zenity --info --title="${TITLE1}" --text "${TEXT14}"
     exit 1

fi

}
###############################################################################

###############################################################################
#Funktion zur Deinstallation der Transparency Skin
function deinsttransparency {

      (
      #Dateien deinstallieren
      echo "${TEXT21}" ; sleep 5
      cd /usr/share/xbmc/addons
	  sudo rm -rf skin.transparency
      echo "${TEXT22}" ; sleep 2
      sudo apt-get -y --force-yes autoremove subversion
      echo "${TEXT23}"
      ) | zenity --progress --title="${TITLE1}" --text="${TEXT24}" --pulsate   

}
###############################################################################

###############################################################################
#Funktion zur Deinstallation der Aeon Skin
function deinstaeon {

      (
      #Dateien deinstallieren
      echo "${TEXT25}" ; sleep 5
      cd /usr/share/xbmc/addons
	  sudo rm -rf skin.aeonmq.3
      echo "${TEXT22}" ; sleep 2
      sudo apt-get -y --force-yes autoremove subversion
	  echo "${TEXT26}"
      ) | zenity --progress --title="${TITLE1}" --text="${TEXT27}" --pulsate  

}
###############################################################################

###############################################################################
#Funktion zur Deinstallation der Cirrus Extended Skin
function deinstcirrus {

      (
      #Dateien deinstallieren
      echo "${TEXT28}" ; sleep 5
      cd /usr/share/xbmc/addons
	  sudo rm -rf skin.cirrus.extended.v2
      echo "${TEXT22}" ; sleep 2
      sudo apt-get -y --force-yes autoremove subversion
	  echo "${TEXT29}"
      ) | zenity --progress --title="${TITLE1}" --text="${TEXT30}" --pulsate  

}
###############################################################################

###############################################################################
#Funktion zur Überprüfung einer Internetverbindung
function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE2}" --text="${TEXT31}"
      exit 1
   else 
      #Aufruf der Funktion menu
      menu
   fi

}
###############################################################################

#Aufruf der Funktion checkconnection
checkconnection
