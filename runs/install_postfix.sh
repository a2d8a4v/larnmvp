#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_postfix {
	export DEBIAN_FRONTEND="noninteractive"
	echo "Package-configuration Postfix-Configuration/Postfix-Configuration select No configuration" | debconf-set-selections
	apt-get -qq install postfix
	service postfix start
	systemctl enable postfix
}
