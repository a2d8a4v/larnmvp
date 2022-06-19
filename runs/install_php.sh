#!/bin/bash

function install_php {
	# install php7.2 or php7.3
	# apt-get -qq install php php-mysql php-json php-curl php-gd php-mbstring php-xml php-xmlrpc php-fpm php7.2-fpm php7.2 php7.2-mysql libapache2-mod-php7.2 libapache2-mod-fcgid php7.2-cgi libapache2-mod-php7.2 php7.2-mbstring php7.2-xsl php7.2-gd php7.2-cli php-pear php7.2-intl php7.2-curl php7.2-zip php7.2-soap php7.2-xml php7.2-imap php7.2-pspell php7.2-recode php7.2-sqlite3 php7.2-tidy php7.2-xmlrpc php-gettext php7.2-common php7.2-json php7.2-opcache php7.2-phpdbg php7.2-ldap php7.2-pgsql php7.2-snmp php7.2-dev
	# apt-get -qq install php${PHP_VER}-fpm php${PHP_VER} php${PHP_VER}-mysql php${PHP_VER}-cgi php${PHP_VER}-mbstring php${PHP_VER}-xsl php${PHP_VER}-gd php${PHP_VER}-cli php${PHP_VER}-intl php${PHP_VER}-curl php${PHP_VER}-zip php${PHP_VER}-soap php${PHP_VER}-xml php${PHP_VER}-imap php${PHP_VER}-pspell php${PHP_VER}-recode php${PHP_VER}-sqlite3 php${PHP_VER}-tidy php${PHP_VER}-xmlrpc php${PHP_VER}-common php${PHP_VER}-json php${PHP_VER}-opcache php${PHP_VER}-phpdbg php${PHP_VER}-ldap php${PHP_VER}-pgsql php${PHP_VER}-snmp php${PHP_VER}-dev php-xmlrpc php-pear php-gettext
	# apt-get -qq install php${PHP_VER}-fpm php${PHP_VER} php${PHP_VER}-mysql php${PHP_VER}-cgi php${PHP_VER}-mbstring php${PHP_VER}-xsl php${PHP_VER}-gd php${PHP_VER}-cli php${PHP_VER}-intl php${PHP_VER}-curl php${PHP_VER}-zip php${PHP_VER}-soap php${PHP_VER}-xml php${PHP_VER}-imap php${PHP_VER}-pspell php${PHP_VER}-sqlite3 php${PHP_VER}-tidy php${PHP_VER}-xmlrpc php${PHP_VER}-common php${PHP_VER}-json php${PHP_VER}-opcache php${PHP_VER}-phpdbg php${PHP_VER}-ldap php${PHP_VER}-pgsql php${PHP_VER}-snmp php${PHP_VER}-dev php-xmlrpc php-pear
	# install php8.1
	# @https://developpaper.com/how-to-install-update-php-8-0-debian-ubuntu/: delete -json due to it already become a default
	apt-get -qq install php${PHP_VER}-fpm php${PHP_VER} php${PHP_VER}-mysql php${PHP_VER}-cgi php${PHP_VER}-mbstring php${PHP_VER}-xsl php${PHP_VER}-gd php${PHP_VER}-cli php${PHP_VER}-intl php${PHP_VER}-curl php${PHP_VER}-zip php${PHP_VER}-soap php${PHP_VER}-xml php${PHP_VER}-imap php${PHP_VER}-pspell php${PHP_VER}-sqlite3 php${PHP_VER}-tidy php${PHP_VER}-xmlrpc php${PHP_VER}-common php${PHP_VER}-opcache php${PHP_VER}-phpdbg php${PHP_VER}-ldap php${PHP_VER}-pgsql php${PHP_VER}-snmp php${PHP_VER}-dev php-xmlrpc php-pear

	# install ssh2 module
	# @https://medium.com/php-7-tutorial/solution-how-to-compile-php7-with-ssh2-f23de4e9c319
	# @https://www.wyr.me/post/604
	apt-get -qq install libssh2-1-dev libssh2-1 php-ssh2

	# install imagick3.4.4
	# @https://gist.github.com/danielstgt/dc1068e577bbd8b6e9a6050a6db1f9c3
	# @https://serverpilot.io/docs/how-to-install-the-php-imagemagick-extension/
	# @https://forum.directadmin.com/threads/php-8-and-imagick-fails.62416/
	mkdir -pv ${dir}/phpmodule
	wget http://pecl.php.net/get/imagick-3.7.0.tgz -O ${dir}/phpmodule/imagick-3.7.0.tgz
	tar xvzf ${dir}/phpmodule/imagick-3.7.0.tgz -C ${dir}/phpmodule
	cd ${dir}/phpmodule/imagick-3.7.0
	# install php-imagick module
	phpize && ./configure && make install
	# go back to install root
	cd ${dir}
}
