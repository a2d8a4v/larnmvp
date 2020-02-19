#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

# @http://gercogandia.blogspot.com/2012/11/automatic-unattended-install-of.html
# @https://askubuntu.com/questions/399903/unattended-phpmyadmin-install-end-up-throwing-errors
# @https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-18-04
function install_phpmyadmin {
	if [[ ${IS_CUSTOM} == "no" ]];then
		echo "nothing to do."
	else
		export DEBIAN_FRONTEND="noninteractive"
		echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
		# echo "phpmyadmin phpmyadmin/app-password-confirm password ${PMA_APP_PASS}" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${mariadbpasswd}" | debconf-set-selections
		# echo "phpmyadmin phpmyadmin/mysql/app-pass password ${PMA_APP_DB_PASS}" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
		apt-get install -y phpmyadmin
		phpenmod mbstring
		systemctl restart apache2

		## -- For security issues, we should take some action like prohibit phpmyadmin by app username and password
		# these two lines below also can use
		# @https://stackoverflow.com/questions/15559359/insert-line-after-first-match-using-sed
		sed -i -e '/^ *DirectoryIndex index.php/b ins' -e b -e ':ins' -e 'a\'$'\n''    AllowOverride All' -e ': done' -e 'n;b done' /etc/apache2/conf-available/phpmyadmin.conf
		mv -f ${INI}/phpmyadmin_ini/phpmyadmin.hta /usr/share/phpmyadmin/.htaccess
		htpasswd -b -c /etc/phpmyadmin/.htpasswd ${PMA_APP_NAME} ${PMA_APP_PASS}
		systemctl restart apache2
	fi
}
