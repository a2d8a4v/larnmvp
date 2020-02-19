#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_mariadb {
	export DEBIAN_FRONTEND="noninteractive"
	echo "mariadb-server-10.4 mysql-server/root_password password ${mariadbpasswd}" | debconf-set-selections
	echo "mariadb-server-10.4 mysql-server/root_password_again password ${mariadbpasswd}" | debconf-set-selections
	apt-get -qq install mariadb-server mariadb-client mariadb-common
	service mysql start
	systemctl enable mariadb
	# thinking about install phpmyadmin silent
}
