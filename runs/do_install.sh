#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function do_install {
	clear
	echo "### Initializing..."
	LOG_T > $dnuloger 2>&1
	check_all_settings # should show
	LOG_T > $dnuloger 2>&1
	preload_arguments > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	do_showing # should show
	LOG_T > $dnuloger 2>&1
	## -- all the install should put under start point
	preload_start_point > $dnuloger 2>&1
	preload_trap > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	preload_hostname
	LOG_T > $dnuloger 2>&1
	preload_modify_ini > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Setup Swap Space..."
	sleep_short_time
	preload_swapspace > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Upgrading Your Repositories..."
	sleep_short_time
	preload_updateupgrade > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	preload_addproperties > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Setup Your Timezone..."
	sleep_short_time
	setting_setuptimezone > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing UFW..."
	sleep_short_time
	install_ufw > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing PHP ${PHP_VER}..."
	echo "--This progess will take some time to finish."
	sleep_short_time
	install_php > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing Apache 2.4..."
	sleep_short_time
	install_apache2 > $dnuloger 2>&1
	setting_php > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing Mariadb 10.4..."
	sleep_short_time
	install_mariadb > $dnuloger 2>&1
	setting_mariadb > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing phpMyAdmin..."
	## -- this should put under Apache2 installation and MariaDB installation for setting both apache2 config and create phpmyadmin database in mariadb
	sleep_short_time
	install_phpmyadmin > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing Postfix"
	## -- if there is no Postfix installed, wp-cli will go to wrong
	sleep_short_time
	install_postfix > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing Letsencrypt Certifacation..."
	sleep_short_time
	## -- should run before setting_apache2
	setting_letsencrypt_apache2 > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	setting_apache2 > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing Fail2ban..."
	## -- this should put under Letsencrypt or vertification would be not successful
	sleep_short_time
	install_fail2ban > $dnuloger 2>&1
	setting_fail2ban > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing Nginx ${NGINX_VER}..."
	echo "--This progess will take 1 hour to finish because of creating DHPARAMS"
	echo "  4096 key to protect webserver connecting to users from attack."
	sleep_short_time
	install_nginx > $dnuloger 2>&1
	setting_nginx > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1 
	echo "### Installing Varnish 6..."
	## -- this should put under Letsencrypt or vertification would be not successful for I added the bot-block function
	sleep_short_time
	install_varnish > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing Redis 5..."
	## -- Notice : This progess will take some time to finish.
	sleep_short_time
	install_redis > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Setting SFTP port..."
	sleep_short_time
	setting_sshd_config > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Installing WordPress..."
	sleep_short_time
	install_wordpress > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Your Custom Setting..."
	sleep_short_time
	setting_cron > $dnuloger 2>&1
	setting_hosts > $dnuloger 2>&1
	setting_system_performance > $dnuloger 2>&1
	setting_sftp_jail > $dnuloger 2>&1
	setting_custom > $dnuloger 2>&1
	LOG_T > $dnuloger 2>&1
	echo "### Done!"
	echo "### Now you can visit your site to check it is running now!"
	sleep_short_time
	LOG_T > $dnuloger 2>&1
	## -- there should not be any programs under "setting_final_point"
	setting_final_point
	# save logs and delete files
	copy_self > $dnuloger 2>&1
	delete_self > $dnuloger 2>&1
}
