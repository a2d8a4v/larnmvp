#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_apache2 {
	# setting apache2
	mv -f ${INI}/apache_ini/ports.conf /etc/apache2/ && chmod -R 644 /etc/apache2/ports.conf && chown -R root:root /etc/apache2/ports.conf
	mv -f ${INI}/apache_ini/apache2.conf /etc/apache2/ && chown -R root:root /etc/apache2/apache2.conf && chmod -R 644 /etc/apache2/apache2.conf

	a2dissite 000-default.conf && rm /etc/apache2/sites-available/000-default.conf
	mv -f ${INI}/apache_ini/${apache2default} /etc/apache2/sites-available/
	chown -R root:root /etc/apache2/sites-available/${apache2default}
	chmod -R 644 /etc/apache2/sites-available/${apache2default}
	a2ensite ${apache2default}

	# log monitor
	mkdir -p -v ${SITE_DIR}/log/apache2
	echo "" | tee ${SITE_DIR}/log/apache2/access.log
	echo "" | tee ${SITE_DIR}/log/apache2/error.log
	chown -R root:www-data ${SITE_DIR}/log
	chmod -R 700 ${SITE_DIR}/log

	mv -f ${INI}/apache_ini/remoteip.conf /etc/apache2/mods-available/ && chown root:root /etc/apache2/mods-available/remoteip.conf && chmod 644 /etc/apache2/mods-available/remoteip.conf

	a2dismod php${PHP_VER} mpm_prefork mpm_event
	a2enmod mpm_worker actions proxy proxy_fcgi remoteip alias rewrite expires headers actions
	systemctl restart php${PHP_VER}-fpm
	service php${PHP_VER}-fpm restart
	service apache2 restart
	systemctl start apache2
	systemctl enable apache2
}
