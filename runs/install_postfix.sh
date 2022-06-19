#!/bin/bash

function install_postfix {
	export DEBIAN_FRONTEND="noninteractive"
	echo "Package-configuration Postfix-Configuration/Postfix-Configuration select No configuration" | debconf-set-selections
	apt-get -qq install postfix
	service postfix start
	systemctl enable postfix
}
