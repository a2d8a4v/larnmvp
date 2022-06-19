#!/bin/bash

## --- Please arrange the files by the order of installation 

##############################################################################################################
## I try to use MVC model to make it easy for drop or import some new functions, just import or remove line ##
##############################################################################################################

function import_runs {
	# basic argument
	. ${runs}/do_arguments_setup.sh
	# preload
	. ${runs}/preload_arguments.sh
	. ${runs}/preload_modify_ini.sh
	. ${runs}/do_showing.sh
	. ${runs}/preload_trap.sh
	. ${runs}/preload_hostname.sh
	. ${runs}/preload_updateupgrade.sh
	. ${runs}/preload_addproperties.sh
	. ${runs}/preload_swapspace.sh
	. ${runs}/preload_start_point.sh

	# install and settings
	. ${runs}/setting_setuptimezone.sh
	. ${runs}/install_ufw.sh
	. ${runs}/install_fail2ban.sh
	. ${runs}/setting_fail2ban.sh
	. ${runs}/install_apache2.sh
	. ${runs}/install_phpmyadmin.sh
	. ${runs}/install_mariadb.sh
	. ${runs}/setting_mariadb.sh
	. ${runs}/install_postfix.sh
	. ${runs}/install_php.sh
	. ${runs}/setting_php.sh
	. ${runs}/setting_apache2.sh
	check_point
	. ${runs}/install_caddy.sh
	. ${runs}/install_nginx.sh
	. ${runs}/nginx_src/install_boringssl.sh
	. ${runs}/nginx_src/install_openssl.sh
	. ${runs}/setting_nginx.sh
	. ${runs}/install_varnish.sh
	. ${runs}/install_redis.sh
	. ${runs}/setting_letsencrypt_apache2.sh
	. ${runs}/let_src/let_ssl_certbot.sh
	. ${runs}/let_src/let_ssl_package_certbot.sh
	. ${runs}/let_src/let_ssl_acme.sh
	. ${runs}/let_src/let_ssl_golang.sh
	. ${runs}/setting_sshd_config.sh
	. ${runs}/install_wordpress.sh
	. ${runs}/setting_custom.sh
	. ${runs}/setting_hosts.sh
	. ${runs}/setting_cron.sh
	. ${runs}/setting_sftp_jail.sh
	. ${runs}/setting_system_performance.sh
	. ${runs}/setting_final_point.sh

	# do install
	. ${runs}/do_install.sh
}
