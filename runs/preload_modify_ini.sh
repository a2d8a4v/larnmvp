#!/bin/bash

#import the settings about the information which typed by users
function preload_modify_ini {
	## -- make apache2 configuration file can be renamed
	sed -i 's/yannyann_apache2_portsconf/'${apaport}'/g' ${INI}/apache_ini/ports.conf
	sed -i 's/yannyann_web_base_slash_droot/'${BASE_DIR2_SED_USE}'/g' ${INI}/apache_ini/apache2.conf
	sed -i 's/yannyann_web_domain/'${website}'/g;s/yannyann_web_base_droot/'${BASE_DIR_SED_USE}'/g;s/yannyann_web_base_slash_droot/'${BASE_DIR2_SED_USE}'/g;s/yannyann_web_droot/'${webrdic}'/g;s/yannyann_apache2_portsconf/'${apaport}'/g;s/yannyann_php_version2or3/'${PHP_VER}'/g' ${INI}/apache_ini/000-default.conf
	# Modify site config file if it is www site
	if [[ -n ${IS_WWW} ]]; then
		if (( ${IS_WWW} == 1 )); then
			sed -i 's/yannyann_web_domain/'${domain}'/g;s/yannyann_web_base_droot/'${BASE_DIR_SED_USE}'/g;s/yannyann_web_droot/'${webrdic}'/g;s/yannyann_apache2_portsconf/'${apaport}'/g;s/yannyann_php_version2or3/'${PHP_VER}'/g' ${INI}/apache_ini/apa.conf
			sed -i -e '\,//\*\*insert_yannyann\*//, { r '${INI}'/apache_ini/apa.conf' -e 'N}' ${INI}/apache_ini/000-default.conf
		fi
	fi
	# Modify for letting WordPress and index.php,etc files at the same other level directory
	if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
		sed -i 's/yannyann_slash_wp_admin_droot/'${WP_AD_SEDUSE}'/g' ${INI}/apache_ini/000-default.conf
	else
		sed -i 's/yannyann_slash_wp_admin_droot//g' ${INI}/apache_ini/000-default.conf
	fi
	# remove //**insert_yannyann*// tag
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/apache_ini/000-default.conf
	# rename the final apache2 site config file
	mv -v ${INI}/apache_ini/000-default.conf ${INI}/apache_ini/${apache2default}

	## -- fake test for ssl
	# Modify site config file if it is www site
	sed -i 's/yannyann_web_domain/'${website}'/g;s/yannyann_php_version2or3/'${PHP_VER}'/g' ${INI}/apache_ini/apafake.conf
	if [[ -n ${IS_WWW} ]]; then
		if (( ${IS_WWW} == 1 )); then
			sed -i 's/yannyann_web_domain/'${domain}'/g;s/yannyann_php_version2or3/'${PHP_VER}'/g' ${INI}/apache_ini/apa_f.conf
			sed -i -e '\,//\*\*insert_yannyann\*//, { r '${INI}'/apache_ini/apa_f.conf' -e 'N}' ${INI}/apache_ini/apafake.conf
		fi
	fi
	# remove //**insert_yannyann*// tag
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/apache_ini/apafake.conf
	# auto update application
	sed -i 's/yannyann_varnish_default/'${varnishdefault}'/g' ${INI}/let_ini/let_renew.sh
	# if autocert fail, use golang to try again
	sed -i 's/yannyann_web_domain/'${website}'/g;s/yannyann_golang_ssl_cert_dic/'${GO_SSL_CERT_DIC}'/g;s/yannyann_email_using/'${EMAIL}'/g' ${INI}/let_ini/let_other.go

	## -- nginx
	# use boringssl or openssl
	if [[ ${NGINX_FROM} == "nginx" ]];then
		if [[ ${SSL_CONF} == "b" ]];then
			mv -f ${INI}/nginx_ini/candidate_default_boringssl ${INI}/nginx_ini/default
			rm -rf ${INI}/nginx_ini/{candidate_default_openssl,candidate_default_google}
		elif [[ ${SSL_CONF} == "o" ]];then
			mv -f ${INI}/nginx_ini/candidate_default_openssl ${INI}/nginx_ini/default
			rm -rf ${INI}/nginx_ini/candidate_default_boringssl,candidate_default_google}
		else
			mv -f ${INI}/nginx_ini/candidate_default_boringssl ${INI}/nginx_ini/default
			rm -rf ${INI}/nginx_ini/{candidate_default_openssl,candidate_default_google}
		fi
	elif [[ ${NGINX_FROM} == "google" ]];then
		mv -f ${INI}/nginx_ini/candidate_default_google ${INI}/nginx_ini/default
		rm -rf ${INI}/nginx_ini/{candidate_default_openssl,candidate_default_boringssl}
	else
		# default use boringssl and nginx from source
		mv -f ${INI}/nginx_ini/candidate_default_boringssl ${INI}/nginx_ini/default
		rm -rf ${INI}/nginx_ini/{candidate_default_openssl,candidate_default_google}
	fi
	# preload file, for I want to reduce the quantity of source code to help me maintenance
	cp -f ${INI}/nginx_ini/default ${INI}/nginx_ini/default2
	cp -f ${INI}/nginx_ini/to_nonwww_nginx.conf ${INI}/nginx_ini/to_nonwww_nginx2.conf
	cp -f ${INI}/nginx_ini/to_www_nginx.conf ${INI}/nginx_ini/to_www_nginx2.conf
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/nginx_ini/default2
	## if website is non www, redirect to non-www under 443
	if [[ -n ${domain_lastc} && -n ${domain_lastb} && -n ${domain_first} ]]; then
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'.'${domain_lastb}'.'${domain_lastc}'/g' ${INI}/nginx_ini/to_www_nginx.conf
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'.'${domain_lastb}'.'${domain_lastc}'/g' ${INI}/nginx_ini/to_nonwww_nginx.conf
	elif [[ -n ${domain_lastb} && -n ${domain_first} ]]; then
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'.'${domain_lastb}'/g' ${INI}/nginx_ini/to_www_nginx.conf
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'.'${domain_lastb}'/g' ${INI}/nginx_ini/to_nonwww_nginx.conf
	elif [[ -n ${domain_first} ]]; then
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_www_nginx.conf
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_nonwww_nginx.conf
	else
		sed -i 's/yannyann_web_domain/'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_www_nginx.conf
		sed -i 's/yannyann_web_domain/'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_nonwww_nginx.conf
	fi
	sed -i -e '\,//\*\*insert_yannyann\*//,  i \    ssl_certificate /etc/letsencrypt/live/'${LET_D}'/fullchain.pem;' ${INI}/nginx_ini/to_www_nginx.conf
	sed -i -e '\,//\*\*insert_yannyann\*//,  i \    ssl_certificate_key /etc/letsencrypt/live/'${LET_D}'/privkey.pem;' ${INI}/nginx_ini/to_www_nginx.conf
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/nginx_ini/to_www_nginx.conf
	sed -i -e '\,//\*\*insert_yannyann\*//,  i \    ssl_certificate /etc/letsencrypt/live/'${LET_D}'/fullchain.pem;' ${INI}/nginx_ini/to_nonwww_nginx.conf
	sed -i -e '\,//\*\*insert_yannyann\*//,  i \    ssl_certificate_key /etc/letsencrypt/live/'${LET_D}'/privkey.pem;' ${INI}/nginx_ini/to_nonwww_nginx.conf
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/nginx_ini/to_nonwww_nginx.conf
	if [[ -n ${IS_WWW} ]]; then
		if (( ${IS_WWW} == 1 )); then
			sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { r '${INI}'/nginx_ini/to_www_nginx.conf' -e 'N}'  ${INI}/nginx_ini/default
			sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { d }' ${INI}/nginx_ini/default
		fi
	else
		sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { r '${INI}'/nginx_ini/to_nonwww_nginx.conf' -e 'N}'  ${INI}/nginx_ini/default
		sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { d }' ${INI}/nginx_ini/default
	fi
	# edit the config about ssl
	sed -i 's/yannyann_web_domain/'${website}'/g;s/yannyann_web_base_droot/'${BASE_DIR_SED_USE}'/g;s/yannyann_web_droot/'${webrdic}'/g;s/yannyann_varnish_port/'${varnport}'/g;s/yannyann_php_version2or3/'${PHP_VER}'/g' ${INI}/nginx_ini/default
	if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
		sed -i 's/yannyann_slash_wp_admin_droot/'${WP_AD_SEDUSE}'/g;s/yannyann_wp_admin_droot//g' ${INI}/nginx_ini/default
	else
		sed -i 's/yannyann_slash_wp_admin_droot//g;s/yannyann_wp_admin_droot/'${WP_AD_SEDUSE}'/g' ${INI}/nginx_ini/default
	fi
	sed -i 's/.*nginx.crt/#&/;s/.*nginx.key/#&/' ${INI}/nginx_ini/default
	sed -i -e '\,//\*\*insert_yannyann\*//,  i \    ssl_certificate /etc/letsencrypt/live/'$LET_D'/fullchain.pem;' ${INI}/nginx_ini/default
	sed -i -e '\,//\*\*insert_yannyann\*//,  i \    ssl_certificate_key /etc/letsencrypt/live/'$LET_D'/privkey.pem;' ${INI}/nginx_ini/default
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/nginx_ini/default
	# if let error, use the self-vertified certification
	sed -i 's/yannyann_web_domain/'${website}'/g;s/yannyann_web_base_droot/'${BASE_DIR_SED_USE}'/g;s/yannyann_web_droot/'${webrdic}'/g;s/yannyann_varnish_port/'${varnport}'/g;s/yannyann_php_version2or3/'${PHP_VER}'/g' ${INI}/nginx_ini/default2
	if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
		sed -i 's/yannyann_slash_wp_admin_droot/'${WP_AD_SEDUSE}'/g;s/yannyann_wp_admin_droot//g' ${INI}/nginx_ini/default2
	else
		sed -i 's/yannyann_slash_wp_admin_droot//g;s/yannyann_wp_admin_droot/'${WP_AD_SEDUSE}'/g' ${INI}/nginx_ini/default2
	fi
	if [[ -n ${domain_first} ]]; then
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_www_nginx2.conf
		sed -i 's/yannyann_web_domain/'${domain_first}'.'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_nonwww_nginx2.conf
	else
		sed -i 's/yannyann_web_domain/'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_www_nginx2.conf
		sed -i 's/yannyann_web_domain/'${domain_middle}'.'${domain_last}'/g' ${INI}/nginx_ini/to_nonwww_nginx2.conf
	fi
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/nginx_ini/to_www_nginx2.conf
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${INI}/nginx_ini/to_nonwww_nginx2.conf
	if [[ -n ${IS_WWW} ]]; then
		if (( ${IS_WWW} == 1 )); then
			sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { r '${INI}'/nginx_ini/to_www_nginx2.conf' -e 'N}'  ${INI}/nginx_ini/default2
			sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { d }' ${INI}/nginx_ini/default2
		fi
	else
		sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { r '${INI}'/nginx_ini/to_nonwww_nginx2.conf' -e 'N}'  ${INI}/nginx_ini/default2
		sed -i -e '\,//\*\*insert_www_or_nonwww_yannyann\*//, { d }' ${INI}/nginx_ini/default2
	fi
	# rename to file
	mv -v ${INI}/nginx_ini/default ${INI}/nginx_ini/${nginxdefault}
	# edit nginx config file
	# for fix upload max limit and tweak performance
	# @https://imququ.com/post/my-nginx-conf-for-wpo.html
	sed -i 's/yannyann_nginx_worker_processes/'${CORE_U}'/g;s/yannyann_nginx_worker_connections/'${ULIMIT_U}'/g;s/client_max_body_size         10m;/client_max_body_size         512m;/g' ${INI}/nginx_ini/nginx.conf
	# edit the log seperate config file
	sed -i 's/yannyann_web_base_droot/'${BASE_DIR_SED_USE}'/g;s/yannyann_web_droot/'${webrdic}'/g' ${INI}/nginx_ini/nginx_log

	## -- caddyserver
	sed -i 's/yannyann_email/'${EMAIL}'/g;s/yannyann_web_domain/'${website}'/g;s/yannyann_php_version2or3/'${PHP_VER}'/g;s/yannyann_web_base_droot/'${BASE_DIR_SED_USE}'/g;s/yannyann_web_droot/'${webrdic}'/g;s/yannyann_apache2_portsconf/'${apaport}'/g;s/yannyann_varnish_port/'${varnport}'/g' ${INI}/caddy_ini/caddyfile
	sed -i 's/yannyann_domain_middle/'${domain_middle}'/g;s/yannyann_domain_last/'${domain_last}'/g' ${INI}/caddy_ini/caddyfile
	sed -i 's/yannyann_caddy_name/'${CAD_APP_NAME}'/g;s/yannyann_caddy_passwd/'${CAD_APP_PASS}'/g' ${INI}/caddy_ini/caddyfile
	if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
		sed -i 's/yannyann_slash_wp_admin_droot/'${WP_AD_SEDUSE}'/g;s/yannyann_wp_admin_droot//g' ${INI}/caddy_ini/caddyfile
	else
		sed -i 's/yannyann_slash_wp_admin_droot//g;s/yannyann_wp_admin_droot/'${WP_AD_SEDUSE}'/g' ${INI}/caddy_ini/caddyfile
	fi

	## -- varnish
	if [[ -n ${IS_WWW} ]]; then
		if (( ${IS_WWW} == 1 )); then
			sed -i 's/yannyann_web_domain/'${domain}'/g' ${INI}/varnish_ini/www_part.vcl
			sed -i -e '\,//\*\*insert_www_or_nonwww_varnish_2_yannyann\*//, { r '${INI}'/varnish_ini/www_part.vcl' -e 'N}' ${INI}/varnish_ini/default.vcl
			sed -i -e '\,//\*\*insert_www_or_nonwww_varnish_yannyann\*//, { d }' ${INI}/varnish_ini/default.vcl
			sed -i -e '\,//\*\*insert_www_or_nonwww_varnish_2_yannyann\*//, { d }' ${INI}/varnish_ini/default.vcl
		fi
	else
		sed -i 's/yannyann_web_domain/'${domain}'/g' ${INI}/varnish_ini/nowww_part.vcl
		sed -i 's/yannyann_web_domain/'${domain}'/g' ${INI}/varnish_ini/nowww_part2.vcl
		sed -i -e '\,//\*\*insert_www_or_nonwww_varnish_yannyann\*//, { r '${INI}'/varnish_ini/nowww_part.vcl' -e 'N}' ${INI}/varnish_ini/default.vcl
		sed -i -e '\,//\*\*insert_www_or_nonwww_varnish_2_yannyann\*//, { r '${INI}'/varnish_ini/nowww_part2.vcl' -e 'N}' ${INI}/varnish_ini/default.vcl
		sed -i -e '\,//\*\*insert_www_or_nonwww_varnish_yannyann\*//, { d }' ${INI}/varnish_ini/default.vcl
		sed -i -e '\,//\*\*insert_www_or_nonwww_varnish_2_yannyann\*//, { d }' ${INI}/varnish_ini/default.vcl
	fi
	sed -i 's/yannyann_varnish_port/'${varnport}'/g;s/default.vcl/'${varnishdefault}'/g' ${INI}/varnish_ini/varnish.service
	sed -i 's/default.vcl/'${varnishdefault}'/g' ${INI}/varnish_ini/varnish_default
	sed -i 's/yannyann_apache2_portsconf/'${apaport}'/g;s/yannyann_web_domain/'${domain}'/g' ${INI}/varnish_ini/default.vcl
	sed -i 's/yannyann_varnish_who_cache/LARNMVP/g' ${INI}/varnish_ini/default.vcl
	mv -v ${INI}/varnish_ini/default.vcl ${INI}/varnish_ini/${varnishdefault}

	## -- redis
	sed -i 's/yannyann_redis_passwd/'${redispasswd}'/g' ${INI}/redis_ini/redis.conf

	## -- WordPress
	sed -i 's/yannyann_web_domain/'${website}'/g;s/yannyann_web_droot/'${webrdic}'/g;s/yannyann_web_base_droot/'${BASE_DIR_SED_USE}'/g' ${INI}/wp_data/wpconfig.conf
	# for redis cache plugin
	sed -i 's/yannyann_wordpress_redis_passwd/'${redispasswd}'/g' ${INI}/wp_data/wpconfig_redis.conf
	# if website url and wp url is not the same
	sed -i 's/yannyann_wp_admin_droot/'${WP_AD_SEDUSE}'/g' ${INI}/wp_data/wpconfig.conf
	if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
		sed -i 's/yannyann_wp_admin_droot//g;s/yannyann_wp_admin_slash_droot//g' ${INI}/wp_data/wp.hta
		sed -i 's/yannyann_wp_admin_droot//g' ${INI}/wp_data/index.php
	else
		sed -i 's/yannyann_wp_admin_droot/'${WP_AD_SEDUSE}'/g;s/yannyann_wp_admin_slash_droot/'${WP_AD2_SEDUSE}'/g' ${INI}/wp_data/wp.hta
		sed -i 's/yannyann_wp_admin_droot/'${WP_AD_SEDUSE}'/g' ${INI}/wp_data/index.php
	fi
	# edit robots.txt
	sed -i 's/yannyann_web_domain/'${website}'/g' ${INI}/wp_data/robots.txt
	if [[ ${IS_CUSTOM} == "no" ]];then
		echo "nothing to do."
	else
		sed -i 's/.*Sitemap/#&/' ${INI}/wp_data/robots.txt
	fi

	## -- fail2ban
	sed -i 's/yannyann_varnish_default/'${varnishdefault}'/g' ${INI}/fail2ban_ini/fail2ban_blacklist.sh
}
