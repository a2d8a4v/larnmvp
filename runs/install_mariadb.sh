#!/bin/bash

function install_mariadb {
	export DEBIAN_FRONTEND="noninteractive"
	echo "mariadb-server-10.4 mysql-server/root_password password ${mariadbpasswd}" | debconf-set-selections
	echo "mariadb-server-10.4 mysql-server/root_password_again password ${mariadbpasswd}" | debconf-set-selections
	apt-get -qq install mariadb-server mariadb-client mariadb-common
	service mysql start
	systemctl enable mariadb
	# thinking about install phpmyadmin silent
}


###
#Package configuration
#
#
#
#
#
#
#
#
# ┌──────────────────────────────────────┤ Configuring mariadb-server-10.3 ├──────────────────────────────────────┐
# │ While not mandatory, it is highly recommended that you set a password for the MariaDB administrative "root"   │ 
# │ user.                                                                                                         │ 
# │                                                                                                               │ 
# │ If this field is left blank, the password will not be changed.                                                │ 
# │                                                                                                               │ 
# │ New password for the MariaDB "root" user:                                                                     │ 
# │                                                                                                               │ 
# │ _____________________________________________________________________________________________________________ │ 
# │                                                                                                               │ 
# │                                                    <Ok>                                                       │ 
# │                                                                                                               │ 
# └───────────────────────────────────────────────────────────────────────────────────────────────────────────────┘ 
#                                                                                                                   
#
#
#
#
#
#
#
#
#
#



# Package configuration










#                                  ┌──────┤ Configuring mariadb-server-10.3 ├──────┐
#                                  │                                               │ 
#                                  │                                               │ 
#                                  │ Repeat password for the MariaDB "root" user:  │ 
#                                  │                                               │ 
#                                  │ _____________________________________________ │ 
#                                  │                                               │ 
#                                  │                    <Ok>                       │ 
#                                  │                                               │ 
#                                  └───────────────────────────────────────────────┘ 
                                                                                   










