#!/bin/bash
#######################################################################
#Skriptname: makeblue.sh
#Autor: Holger (alias spocky184)
#Datum: 04.06.2012
#Funktion: installiert makemkv inkl. XBMC Addon
#
#Changelog:
#
#ToDo:
# - Deinstallationsroutine hinzufügen
# - prüfen warum das XBMC AddOn nicht bzw. nicht mehr richtig funktioniert
#######################################################################

#Sprache des installierten Systems erkennen
LANGCONF=`echo $LANG`
#wenn de_DE.UTF-8 dann deutsche Dialoge
if [ "$LANGCONF" = "de_DE.UTF-8" ]; then

	TITLE1="makemkv Installation:"
	TITLE2="Internetverbindung:"
	TEXT1="Soll makemkv installiert werden?"
	TEXT2="# Paketquellen werden aktualisiert..."
	TEXT3="# curl wird installiert..."
	TEXT4="# Versionsinformationen werden ermittelt..."
	TEXT5="# Paketabhaengigkeiten werden installiert..."
	TEXT6="# makemkv-bin wird heruntergeladen..."
	TEXT7="# makemkv-bin wird entpackt..."
	TEXT8="# makemkv-oss wird heruntergeladen..."
	TEXT9="# makemkv-oss wird entpackt..."
	TEXT10="# Abfrage der Eula wird deaktiviert..."
	TEXT11="# makemkv-bin wird kompiliert..."
	TEXT12="# makemkv-bin wird installiert..."
	TEXT13="# makemkv-oss wird kompiliert..."
	TEXT14="# makemkv-oss wird installiert..."
	TEXT15="# XBMC Integration wird installiert..."
	TEXT16="# makemkv installiert! Fertig!"
	TEXT17="makemkv wird installiert..."
	TEXT18="Aktion abgebrochen!"
	TEXT19="Keine Internetverbindung, Installation nicht moeglich. Bitte Netzwerkkonfiguration ueberpruefen"

else

	TITLE1="makemkv installation:"
	TITLE2="Internet connection:"
	TEXT1="Should makemkv be installed?"
	TEXT2="# updating package repositories..."
	TEXT3="# installing curl..."
	TEXT4="# getting version informations..."
	TEXT5="# installing package dependencies..."
	TEXT6="# downloading makemkv-bin..."
	TEXT7="# unpacking makemkv-bin..."
	TEXT8="# downloading makemkv-oss..."
	TEXT9="# unpacking makemkv-oss..."
	TEXT10="# deactivating Eula question..."
	TEXT11="# compiling makemkv-bin..."
	TEXT12="# installing makemkv-bin..."
	TEXT13="# compiling makemkv-oss..."
	TEXT14="# installing makemkv-oss..."
	TEXT15="# installing XBMC integration..."
	TEXT16="# makemkv installed! Ready!"
	TEXT17="makemkv is being installed..."
	TEXT18="Action canceled!"
	TEXT19="No internet connection, installation not possible. Please check your network configuration"

fi

#######################################################################
function instmakemkv {

   zenity --question --title="${TITLE1}" --text="${TEXT1}"

   if [ $? = 0 ]; then
   
      (
      #kurze Denkpause
	  sleep 2
	  #verfügbare Version überprüfen
      echo "${TEXT2}" ; sleep 2
      sudo apt-get update -y --force-yes
      echo "${TEXT3}" ; sleep 2
      sudo apt-get install -y --force-yes curl
      echo "${TEXT4}" ; sleep 2
      curl 'http://www.makemkv.com/forum2/viewtopic.php?f=3&t=224' | grep -Eo "makemkv_v.{16}" 2>&1 > ~/versions.txt
      BIN=`head -n1 ~/versions.txt`
      OSS=`tail -n1 ~/versions.txt`
      curl 'http://www.makemkv.com/forum2/viewtopic.php?f=3&t=224' | grep -Eo "makemkv_v.{9}" 2>&1 > ~/dirs.txt
      BINDIR=`head -n1 ~/dirs.txt`
      OSSDIR=`tail -n1 ~/dirs.txt`
      #clear
      #echo "Binary Package: $BIN"
      #echo "Source Package: $OSS"
      echo "${TEXT5}" ; sleep 2
      sudo apt-get install -y --force-yes build-essential libc6-dev libssl-dev libgl1-mesa-dev libqt4-dev
      mkdir ~/makemkv
      cd ~/makemkv
      echo "${TEXT6}" ; sleep 2
      wget http://www.makemkv.com/download/$BIN
      echo "${TEXT7}" ; sleep 2
      tar xzvf $BIN
      echo "${TEXT8}" ; sleep 2
      wget http://www.makemkv.com/download/$OSS
      echo "${TEXT9}" ; sleep 2
      tar xzvf $OSS
      cd ~/makemkv/$BINDIR
      #Abfrage der Eula deaktivieren
      echo "${TEXT10}" ; sleep 2
      sed -i 's/$LESS/#$LESS /' ~/makemkv/$BINDIR/src/ask_eula.sh
      sed -i 's/read -e ANSWER/ANSWER="yes"/' ~/makemkv/$BINDIR/src/ask_eula.sh
      echo "${TEXT11}" ; sleep 2
      make -f makefile.linux
      # Eingabe :q und danach yes (Bestätigung der Lizenz)
      echo "${TEXT12}" ; sleep 2
      sudo make -f makefile.linux install
      cd ~/makemkv/$OSSDIR
      echo "${TEXT13}" ; sleep 2
      make -f makefile.linux
      echo "${TEXT14}" ; sleep 2
      sudo make -f makefile.linux install
      # #Beta-Key in settings.conf eintragen
	  # echo 'app_Key = "T-Sitx5LxEXqP3UVcXWEbszE4Aj24b2k1OOGvAWFqXb5P11X42EoO_e2UpLcjS96EaS@"' > ~./MakeMKV/settings.conf
	  #temporäre Datei löschen
      rm -f ~/versions.txt
      rm -f ~/dirs.txt

      #makemkv XBMC Integration ! 
      echo "${TEXT15}" ; sleep 2
      cd ~/.xbmc/addons
      #wget http://downloads.ztreambox.org/ztreamboxlive-bluray/plugin.video.makemkv.zip
      #wget http://downloads.ztreambox.org/ztreamboxlive/xbmc/bluray/plugin.makemkvbluray.zip
      wget http://www.bultsblog.com/plugin.makemkvbluray.zip
	  #unzip -o plugin.video.makemkv.zip
      #rm -f plugin.video.makemkv.zip
      unzip -o plugin.makemkvbluray.zip
      rm -f plugin.makemkvbluray.zip

      echo "${TEXT16}" ; sleep 2
      ) | zenity --progress --title="${TITLE1}" --text="${TEXT17}" --pulsate
	  
else

     #Abbrechen
     zenity --info --title="${TITLE1}" --text "${TEXT18}"
     exit 1

fi   
   
}

function checkconnection {

   IP=`nslookup downloads.ztreambox.org | grep "Address: "`
   if [ -z "$IP" ]; then
      zenity --warning --title="${TITLE2}" --text="${TEXT19}"
      exit 1
   else 
      #Aufruf der Funktion instmakemkv
	  instmakemkv
   fi

}

#Aufruf der Funktion checkconnection
checkconnection
