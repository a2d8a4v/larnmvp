#!/bin/bash

function install_ufw {
	# [[ $(dpkg-query -W -f='${db:Status-Abbrev}\n' git 2>/dev/null) != *ii* ]] && \ apt-get -qq -y --no-install-recommends install git
	apt-get -qq install ufw
	ufw default deny incoming && ufw allow http && ufw allow https && ufw allow ${sftpport}
	ufw allow 21/tcp
	ufw disable && echo "y" | ufw enable
}
