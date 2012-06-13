#!/bin/bash

clear
echo "##################################################"
echo "# configuring xbmc ...                           #"
echo "##################################################"
sleep 3

(

#create directories
if [ -f "lang.de" ]; then
	mkdir -p /etc/skel/{Videos,Musik,Bilder,Recordings}
else
	mkdir -p /etc/skel/{Videos,Music,Pictures,Recordings}
fi
mkdir -p /etc/skel/.xbmc/{userdata/keymaps,addons,tvlogos}

#guisettings.xml
if [ -f "lang.de" ]; then
cat << EOF | tee /etc/skel/.xbmc/userdata/guisettings.xml
<settings>
	<audiooutput>
		<audiodevice>custom</audiodevice>
		<channellayout>0</channellayout>
		<customdevice>plug:both</customdevice>
		<mode>2</mode>
		<passthroughdevice>alsa:hdmi</passthroughdevice>
		<ac3passthrough>false</ac3passthrough>
		<dtspassthrough>false</dtspassthrough>
	</audiooutput>
	<defaultvideosettings>
        <deinterlacemode>0</deinterlacemode>
        <interlacemethod>1</interlacemethod>
        <scalingmethod>1</scalingmethod>
        <noisereduction>0.000000</noisereduction>
        <postprocess>false</postprocess>
        <sharpness>0.000000</sharpness>
        <viewmode>0</viewmode>
        <zoomamount>1.000000</zoomamount>
        <pixelratio>1.000000</pixelratio>
        <verticalshift>0.000000</verticalshift>
        <volumeamplification>0.000000</volumeamplification>
        <outputtoallspeakers>false</outputtoallspeakers>
        <showsubtitles>false</showsubtitles>
        <brightness>50.000000</brightness>
        <contrast>50.000000</contrast>
        <gamma>20.000000</gamma>
        <audiodelay>0.000000</audiodelay>
        <subtitledelay>0.000000</subtitledelay>
        <autocrop>false</autocrop>
        <nonlinstretch>false</nonlinstretch>
    </defaultvideosettings>
	<dvds>
		<automenu>true</automenu>
	</dvds>
    <epg>
        <daystodisplay>2</daystodisplay>
        <defaultguideview>3</defaultguideview>
        <epgupdate>120</epgupdate>
        <ignoredbforclient>true</ignoredbforclient>
        <preventupdateswhileplayingtv>false</preventupdateswhileplayingtv>
        <resetepg></resetepg>
    </epg>
	<filelists>
		<allowfiledeletion>true</allowfiledeletion>
		<showextensions>false</showextensions>
	</filelists>
	<input>
		<enablemouse>false</enablemouse>
	</input>
	<locale>
		<country>Deutschland</country>
		<language>German</language>
		<timezone>Europe/Berlin</timezone>
		<timezonecountry>Germany</timezonecountry>
	</locale>
	<lookandfeel>
		<soundskin>OFF</soundskin>
	</lookandfeel>
	<pvrmanager>
        <backendchannelorder>true</backendchannelorder>
        <channelmanager></channelmanager>
        <channelscan></channelscan>
        <enabled>false</enabled>
        <resetdb></resetdb>
        <syncchannelgroups>true</syncchannelgroups>
        <usebackendchannelnumbers>false</usebackendchannelnumbers>
    </pvrmanager>
    <pvrmenu>
        <closechannelosdonswitch>true</closechannelosdonswitch>
        <hidevideolength>true</hidevideolength>
        <iconpath>/home/xbmc/.xbmc/tvlogos/</iconpath>
        <infoswitch>true</infoswitch>
        <infotime>5</infotime>
        <infotimeout>true</infotimeout>
        <searchicons></searchicons>
    </pvrmenu>
    <pvrplayback>
        <channelentrytimeout>0</channelentrytimeout>
        <playminimized>true</playminimized>
        <scantime>15</scantime>
        <signalquality>true</signalquality>
        <startlast>0</startlast>
        <switchautoclose>true</switchautoclose>
    </pvrplayback>
    <pvrpowermanagement>
        <backendidletime>15</backendidletime>
        <dailywakeup>false</dailywakeup>
        <dailywakeuptime>00:00:00</dailywakeuptime>
        <enabled>false</enabled>
        <prewakeup>15</prewakeup>
        <setwakeupcmd>/usr/bin/setwakeup.sh</setwakeupcmd>
    </pvrpowermanagement>
    <pvrrecord>
        <defaultlifetime>99</defaultlifetime>
        <defaultpriority>50</defaultpriority>
        <instantrecordtime>180</instantrecordtime>
        <marginend>10</marginend>
        <marginstart>2</marginstart>
        <timernotifications>true</timernotifications>
    </pvrrecord>	
	<scrapers>
        <langfallback>false</langfallback>
        <moviesdefault>metadata.ofdb.de</moviesdefault>
        <musicvideosdefault>metadata.yahoomusic.com</musicvideosdefault>
        <tvshowsdefault>metadata.tvdb.com</tvshowsdefault>
    </scrapers>
	<screensaver>
		<time>10</time>
	</screensaver>
	<services>
		<airplay>true</airplay>
		<devicename>ztreambox</devicename>
		<esallinterfaces>true</esallinterfaces>
		<webserver>true</webserver>
		<webserverpassword>xbmc</webserverpassword>
	</services>
	<smb>
		<workgroup>HOME</workgroup>
	</smb>
	<videoplayer>
		<adjustrefreshrate>true</adjustrefreshrate>
		<stretch43>4</stretch43>
		<usedisplayasclock>true</usedisplayasclock>
		<usevaapi>false</usevaapi>
		<usevdpau>true</usevdpau>
	</videoplayer>
</settings>
EOF
else
cat << EOF | tee /etc/skel/.xbmc/userdata/guisettings.xml
<settings>
	<audiooutput>
		<audiodevice>custom</audiodevice>
		<channellayout>0</channellayout>
		<customdevice>plug:both</customdevice>
		<mode>2</mode>
		<passthroughdevice>alsa:hdmi</passthroughdevice>
		<ac3passthrough>false</ac3passthrough>
		<dtspassthrough>false</dtspassthrough>
	</audiooutput>
	<defaultvideosettings>
        <deinterlacemode>0</deinterlacemode>
        <interlacemethod>1</interlacemethod>
        <scalingmethod>1</scalingmethod>
        <noisereduction>0.000000</noisereduction>
        <postprocess>false</postprocess>
        <sharpness>0.000000</sharpness>
        <viewmode>0</viewmode>
        <zoomamount>1.000000</zoomamount>
        <pixelratio>1.000000</pixelratio>
        <verticalshift>0.000000</verticalshift>
        <volumeamplification>0.000000</volumeamplification>
        <outputtoallspeakers>false</outputtoallspeakers>
        <showsubtitles>false</showsubtitles>
        <brightness>50.000000</brightness>
        <contrast>50.000000</contrast>
        <gamma>20.000000</gamma>
        <audiodelay>0.000000</audiodelay>
        <subtitledelay>0.000000</subtitledelay>
        <autocrop>false</autocrop>
        <nonlinstretch>false</nonlinstretch>
    </defaultvideosettings>
	<dvds>
		<automenu>true</automenu>
	</dvds>
    <epg>
        <daystodisplay>2</daystodisplay>
        <defaultguideview>3</defaultguideview>
        <epgupdate>120</epgupdate>
        <ignoredbforclient>true</ignoredbforclient>
        <preventupdateswhileplayingtv>false</preventupdateswhileplayingtv>
        <resetepg></resetepg>
    </epg>
	<filelists>
		<allowfiledeletion>true</allowfiledeletion>
		<showextensions>false</showextensions>
	</filelists>
	<input>
		<enablemouse>false</enablemouse>
	</input>
	<lookandfeel>
		<soundskin>OFF</soundskin>
	</lookandfeel>
	<pvrmanager>
        <backendchannelorder>true</backendchannelorder>
        <channelmanager></channelmanager>
        <channelscan></channelscan>
        <enabled>false</enabled>
        <resetdb></resetdb>
        <syncchannelgroups>true</syncchannelgroups>
        <usebackendchannelnumbers>false</usebackendchannelnumbers>
    </pvrmanager>
    <pvrmenu>
        <closechannelosdonswitch>true</closechannelosdonswitch>
        <hidevideolength>true</hidevideolength>
        <iconpath>/home/xbmc/.xbmc/tvlogos/</iconpath>
        <infoswitch>true</infoswitch>
        <infotime>5</infotime>
        <infotimeout>true</infotimeout>
        <searchicons></searchicons>
    </pvrmenu>
    <pvrplayback>
        <channelentrytimeout>0</channelentrytimeout>
        <playminimized>true</playminimized>
        <scantime>15</scantime>
        <signalquality>true</signalquality>
        <startlast>0</startlast>
        <switchautoclose>true</switchautoclose>
    </pvrplayback>
    <pvrpowermanagement>
        <backendidletime>15</backendidletime>
        <dailywakeup>false</dailywakeup>
        <dailywakeuptime>00:00:00</dailywakeuptime>
        <enabled>false</enabled>
        <prewakeup>15</prewakeup>
        <setwakeupcmd>/usr/bin/setwakeup.sh</setwakeupcmd>
    </pvrpowermanagement>
    <pvrrecord>
        <defaultlifetime>99</defaultlifetime>
        <defaultpriority>50</defaultpriority>
        <instantrecordtime>180</instantrecordtime>
        <marginend>10</marginend>
        <marginstart>2</marginstart>
        <timernotifications>true</timernotifications>
    </pvrrecord>	
	<screensaver>
		<time>10</time>
	</screensaver>
	<services>
		<airplay>true</airplay>
		<devicename>ztreambox</devicename>
		<esallinterfaces>true</esallinterfaces>
		<webserver>true</webserver>
		<webserverpassword>xbmc</webserverpassword>
	</services>
	<smb>
		<workgroup>HOME</workgroup>
	</smb>
	<videoplayer>
		<adjustrefreshrate>true</adjustrefreshrate>
		<stretch43>4</stretch43>
		<usedisplayasclock>true</usedisplayasclock>
		<usevaapi>false</usevaapi>
		<usevdpau>true</usevdpau>
	</videoplayer>
</settings>
EOF
fi

#RssFeeds.xml
if [ -f "lang.de" ]; then
cat << EOF | tee /etc/skel/.xbmc/userdata/RssFeeds.xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<rssfeeds>
  <!-- RSS feeds. To have multiple feeds, just add a feed to the set. You can also have multiple sets. 	!-->
  <!-- To use different sets in your skin, each must be called from skin with a unique id.             	!-->
  <set id="1">
	<feed updateinterval="30">http://www.ztreambox.org/feed</feed>
	<!-- feed updateinterval="30">http://feeds.feedburner.com/yavdr</feed !-->
	<feed updateinterval="30">http://feeds.feedburner.com/xbmc</feed>
  </set>
</rssfeeds>
EOF
else
cat << EOF | tee /etc/skel/.xbmc/userdata/RssFeeds.xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<rssfeeds>
  <!-- RSS feeds. To have multiple feeds, just add a feed to the set. You can also have multiple sets. 	!-->
  <!-- To use different sets in your skin, each must be called from skin with a unique id.             	!-->
  <set id="1">
	<feed updateinterval="30">http://www.ztreambox.com/feed</feed>
	<!-- feed updateinterval="30">http://feeds.feedburner.com/yavdr</feed !-->
	<feed updateinterval="30">http://feeds.feedburner.com/xbmc</feed>
  </set>
</rssfeeds>
EOF
fi

#sources.xml
if [ -f "lang.de" ];then
cat << EOF | tee /etc/skel/.xbmc/userdata/sources.xml
<sources>
	<programs>
		<default pathversion="1"></default>
	</programs>
	<video>
		<default pathversion="1"></default>
		<source>
			<name>Videos (Lokal)</name>
			<path pathversion="1">/home/xbmc/Videos/</path>
		</source>
		<source>
			<name>TV Aufzeichnungen (Lokal)</name>
			<path pathversion="1">/home/xbmc/Recordings/</path>
		</source>
	</video>
	<music>
		<default pathversion="1"></default>
		<source>
			<name>Musik (Lokal)</name>
			<path pathversion="1">/home/xbmc/Musik/</path>
		</source>
	</music>
	<pictures>
		<default pathversion="1"></default>
		<source>
			<name>Bilder (Lokal)</name>
			<path pathversion="1">/home/xbmc/Bilder/</path>
		</source>
	</pictures>
	<files>
		<default pathversion="1"></default>
	</files>
</sources>
EOF
else
cat << EOF | tee /etc/skel/.xbmc/userdata/sources.xml
<sources>
	<programs>
		<default pathversion="1"></default>
	</programs>
	<video>
		<default pathversion="1"></default>
		<source>
			<name>Videos (Local)</name>
			<path pathversion="1">/home/xbmc/Videos/</path>
		</source>
		<source>
			<name>TV Recordings (Local)</name>
			<path pathversion="1">/home/xbmc/Recordings/</path>
		</source>
	</video>
	<music>
		<default pathversion="1"></default>
		<source>
			<name>Music (Local)</name>
			<path pathversion="1">/home/xbmc/Music/</path>
		</source>
	</music>
	<pictures>
		<default pathversion="1"></default>
		<source>
			<name>Pictures (Local)</name>
			<path pathversion="1">/home/xbmc/Pictures/</path>
		</source>
	</pictures>
	<files>
		<default pathversion="1"></default>
	</files>
</sources>
EOF
fi

#Lircmap.xml and Keymap.
#wget http://remaster.ztreambox.org/xbmc/Lircmap.xml -O /etc/skel/.xbmc/userdata/Lircmap.xml
#wget http://remaster.ztreambox.org/xbmc/Keymap.xml -O /etc/skel/.xbmc/userdata/keymaps/Keymap.xml
cp zbremaster/xbmc/Lircmap.xml /etc/skel/.xbmc/userdata/Lircmap.xml
cp zbremaster/xbmc/Keymap.xml /etc/skel/.xbmc/userdata/keymaps/Keymap.xml
	
#xbmc addons
repoURL="http://mirrors.xbmc.org/addons/eden/"
ADDONSLIST=(script.rss.editor script.xbmc.audio.mixer metadata.ofdb.de metadata.kino.de plugin.audio.icecast webinterface.XWMM plugin.program.advanced.launcher script.linux.nm)
for k in "${ADDONSLIST[@]}" ; do
	echo " $k"
	addonURL="$repoURL$k/"
	latestPackage=$(curl -x "" -s -f $addonURL | grep -o "$k[^\"]*.zip" | sort -r -k2 -t_ -n | head -n 1)
	if [ ! -f $latestPackage ]; then
	wget --no-proxy -q "$addonURL$latestPackage"
		if [ "$?" -ne "0" ] || [ ! -f $latestPackage ] ; then
			echo "Needed package ($k) not found, exiting..."
		fi
	fi
	unzip -q $latestPackage -d /etc/skel/.xbmc/addons
	rm -f $latestPackage
done

#tv-logos
if [ ! -f "/etc/skel/.xbmc/tvlogos/zdf.png" ]; then
	#wget http://remaster.ztreambox.org/dvb/tvlogos.zip -O /etc/skel/.xbmc/tvlogos/tvlogos.zip
	cp zbremaster/dvb/tvlogos.zip /etc/skel/.xbmc/tvlogos/tvlogos.zip
	unzip -o /etc/skel/.xbmc/tvlogos/tvlogos.zip -d /etc/skel/.xbmc/tvlogos
	rm -f /etc/skel/.xbmc/tvlogos/tvlogos.zip
fi

) 2>&1 | tee 41-xbmcconfig.log
