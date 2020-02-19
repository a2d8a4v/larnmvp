#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_setuptimezone {
	#fix the time
	ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
	dpkg-reconfigure --frontend noninteractive tzdata
	#install ntpdate
	apt-get -qq install ntpdate
	ntpdate watch.stdtime.gov.tw
}
