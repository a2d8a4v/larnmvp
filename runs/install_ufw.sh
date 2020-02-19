#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_ufw {
	# [[ $(dpkg-query -W -f='${db:Status-Abbrev}\n' git 2>/dev/null) != *ii* ]] && \ apt-get -qq -y --no-install-recommends install git
	apt-get -qq install ufw
	ufw default deny incoming && ufw allow http && ufw allow https && ufw allow ${sftpport}
	ufw allow 21/tcp
	ufw disable && echo "y" | ufw enable
}
