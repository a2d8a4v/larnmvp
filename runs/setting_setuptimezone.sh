#!/bin/bash

function setting_setuptimezone {
	#fix the time
	ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
	dpkg-reconfigure --frontend noninteractive tzdata
	#install ntpdate
	apt-get -qq install ntpdate
	ntpdate watch.stdtime.gov.tw
}
