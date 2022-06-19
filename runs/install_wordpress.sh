#!/bin/bash

function install_wordpress {
	## --- Install WordPress

	#  Using WP-CLI to run all the things about wordpress
	# it seems that we should not rename wp-cli.phar or it cannot work, but I don't know why, the test environment is php7.3
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && chmod a+x /usr/local/bin/wp
	#@@@ certifate whether we download wp-cli was successful or not

	# make a new diretory for wordpress
	if [[ ${SITE_DIR} == ${WP_ADMIN_DIR} ]];then
		mkdir -p -v ${SITE_DIR}
	else
		mkdir -p -v ${WP_ADMIN_DIR}
	fi

	# download wordpress
	if [[ ${IS_BETA_WP} == "no" ]]; then
		wp core download --path=${WP_ADMIN_DIR} --version=${WP_VER} --force --quiet --allow-root
	elif [[ ${IS_BETA_WP} == "yes" ]]; then
		mkdir -v -p ${dir}/wp_download
		wget https://wordpress.org/wordpress-5.1-RC2.tar.gz -O ${dir}/wp_download/wordpress.tar.gz
		tar zxf ${dir}/wp_download/wordpress.tar.gz --directory=${dir}/wp_download
		cp -rf ${dir}/wp_download/wordpress ${WP_ADMIN_DIR}
	else
		wp core download --path=${WP_ADMIN_DIR} --version=${WP_VER} --force --quiet --allow-root
	fi

	if [[ -e ${WP_ADMIN_DIR}/readme.html ]] && [[ -e ${WP_ADMIN_DIR}/license.txt ]]; then
		rm -R ${WP_ADMIN_DIR}/{readme.html,license.txt}
	fi
	
	if [[ -z ${LEN_WP_AD} ]];then
		if [[ -z ${WP_AD} ]];then
			if [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
				mv -f ${INI}/wp_data/{index.php,robots.txt} ${SITE_DIR}/
				mv -f ${INI}/wp_data/wp.hta ${SITE_DIR}/.htaccess
			else
				mv -f ${INI}/wp_data/{index.php,robots.txt} ${SITE_DIR}/
				mv -f ${INI}/wp_data/wp.hta ${SITE_DIR}/.htaccess
			fi
		fi
	else
		if (( ${LEN_WP_AD} == 0 )) && [[ -z ${WP_AD} ]];then
			mv -f ${INI}/wp_data/{index.php,robots.txt} ${SITE_DIR}/
			mv -f ${INI}/wp_data/wp.hta ${SITE_DIR}/.htaccess
		elif (( ${LEN_WP_AD} != 0 )) && [[ -z ${WP_AD} ]]; then
			mv -f ${INI}/wp_data/{index.php,robots.txt} ${SITE_DIR}/
			mv -f ${INI}/wp_data/wp.hta ${SITE_DIR}/.htaccess
		else
			if [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
				mv -f ${INI}/wp_data/{index.php,robots.txt} ${WP_ADMIN_DIR}/
				mv -f ${INI}/wp_data/wp.hta ${WP_ADMIN_DIR}/.htaccess
			else
				mv -f ${INI}/wp_data/{index.php,robots.txt} ${SITE_DIR}/
				mv -f ${INI}/wp_data/wp.hta ${SITE_DIR}/.htaccess
			fi
		fi
	fi

	# This should be setted forehead or will let wp-cli can not create new wp-config.php successfully
	# do not lose the three line below, or it will run a white screen page.
	chmod -R 755 ${SITE_DIR}/
	chmod -R 755 ${SITE_DIR}/*
	chown root:root ${SITE_DIR} -R
	# chown -R www-data:www-data ${WP_ADMIN_DIR}/*

	# @https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed
	# setting wp-config.php
	wp core config --dbname=${dbname} --dbuser=${ADMDBNAME} --dbpass=${PASSWDDBNAME} --dbhost="localhost" --dbprefix=${WP_PREFIX_RANDOM} --allow-root --path=${WP_ADMIN_DIR} --force --extra-php <<PHP
//**insert_yannyann*//
//**insert_yannyann_redis*//
PHP

	# install database
	#@@@ dot not add "/" at the end of url in --url option
	wp core install --url="https://${website}" --title="LARNMVP - yannyann.com" --admin_user="${WPUSER}" --admin_password="${WPASSWD}" --admin_email="${EMAIL}" --path=${WP_ADMIN_DIR} --quiet --allow-root
	# @https://codex.wordpress.org/Changing_The_Site_URL
	if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
		wp option update siteurl "https://${website}" --path=${WP_ADMIN_DIR} --quiet --allow-root
	else
		if [[ ${WP_ADMIN_DIR} != ${SITE_DIR} ]];then
			wp option update siteurl "https://${website}/${WP_AD}" --path=${WP_ADMIN_DIR} --quiet --allow-root
		fi
	fi

	# install language packages
	# if (( $TRY == 1 ));then
	wp language core install zh_TW --activate --path=${WP_ADMIN_DIR} --quiet --allow-root
	# change the timezone
	# @https://developer.wordpress.org/cli/commands/option/update/
	wp option update timezone_string "Asia/Taipei" --path=${WP_ADMIN_DIR} --quiet --allow-root
	# fi

	# config ssl and wp-config.php file
	sed -i -e '\,//\*\*insert_yannyann\*//, { r '${INI}'/wp_data/wpconfig.conf' -e 'N}' ${WP_ADMIN_DIR}/wp-config.php
	sed -i -e '\,//\*\*insert_yannyann\*//, { d }' ${WP_ADMIN_DIR}/wp-config.php
	# setting for wp debug true
	wp config set WP_DEBUG true --raw --path=${WP_ADMIN_DIR} --quiet --allow-root

	# setting for WordPress Memory usage limit
	wp config set WP_MEMORY_LIMIT 256M --path=${WP_ADMIN_DIR} --quiet --allow-root

	## --- Install custom themes and plugins for developers
	if [[ ${IS_CUSTOM} == "no" ]];then
		echo "nothing to do."
	else
		# install wp file manager
		wp plugin install wp-file-manager --activate --path=${WP_ADMIN_DIR} --quiet --allow-root || echo
		# install query monitor
		wp plugin install query-monitor --activate --path=${WP_ADMIN_DIR} --quiet --allow-root || echo
		# install redis cache plugin
		wp plugin install wp-redis --path=${WP_ADMIN_DIR} --quiet --allow-root || echo
		# install error log monitor
		wp plugin install error-log-monitor --activate --path=${WP_ADMIN_DIR} --quiet --allow-root || echo
		# install Health Check & Troubleshooting
		wp plugin install health-check --activate --path=${WP_ADMIN_DIR} --quiet --allow-root || echo
		# install WP Rollback
		wp plugin install wp-rollback --activate --path=${WP_ADMIN_DIR} --quiet --allow-root || echo
		# install downgrade
		wp plugin install wp-downgrade --activate --path=${WP_ADMIN_DIR} --quiet --allow-root || echo
	fi


	# touch a new error file for query monitor
	touch ${WP_ADMIN_DIR}/php-errors.log && chown www-data:www-data ${WP_ADMIN_DIR}/php-errors.log

	# Setting redis cache plugin
	if [[ ${IS_CUSTOM} == "no" ]];then
		sed -i -e '\,//\*\*insert_yannyann_redis\*//, { d }' ${WP_ADMIN_DIR}/wp-config.php
	else
		#@@@ for sustainable reason, close wp-redis at first
		# wp redis enable --path=${WP_ADMIN_DIR} --quiet --allow-root
		# sed -i -e '\,//\*\*insert_yannyann_redis\*//, { r '${INI}'/wp_data/wpconfig_redis.conf' -e 'N}' ${WP_ADMIN_DIR}/wp-config.php
		sed -i -e '\,//\*\*insert_yannyann_redis\*//, { d }' ${WP_ADMIN_DIR}/wp-config.php
	fi

	# delete akismet and hello dolly because of uselessness
	wp plugin delete akismet --path=${WP_ADMIN_DIR} --quiet --allow-root
	wp plugin delete hello --path=${WP_ADMIN_DIR} --quiet --allow-root

	## --- create post for developer using
	# use update to modify for reducing the quantity of programming
	if [[ ${IS_CUSTOM} == "no" ]];then
		echo "nothing to do."
	else
		#@@@ for security issue, do not update post with $scfg content
		# wp post update 1 --path=${WP_ADMIN_DIR} --quiet --allow-root --post_title='For Developer' --post_content="$( cat ${scfg} )"
		wp post update 1 --path=${WP_ADMIN_DIR} --quiet --allow-root --post_title='For Developer' --post_content="$( cat ${scfg} && echo -e "\nwp redis enable --path=${WP_ADMIN_DIR} --quiet --allow-root\n" && cat ${INI}/wp_data/wpconfig_redis.conf )"
		# wp post update 1 --path=${WP_ADMIN_DIR} --quiet --allow-root --post_title='For Developer' --post_content="$( echo -e '# The account name in WordPress' && echo -e 'WPUSER="'${WPUSER}'"' && echo -e '# The password of account in WordPress' && echo -e 'WPASSWD="'${WPASSWD}'"' )"
		echo "nothing to do."
	fi

	## -- Set the security and permission
	# also fixing the permission for wordpress, because wp-cli install in root adminitrator and it will lead to some permission errors when using wordpress like deny of uploading a file

	# first is the base folders
	chown root:root ${BASE_DIR}
	chmod -R g+w ${BASE_DIR}
	chmod -R 755 ${SITE_DIR}
	chown root:root ${SITE_DIR}
	chown root:www-data ${SITE_DIR}/log -R && chmod 700 ${SITE_DIR}/log -R
	chown www-data:www-data ${WP_ADMIN_DIR}/*.*

	# setting for wordpress core and wp-content
	chown -R www-data:www-data ${WP_ADMIN_DIR}/wp-content/
	chown -R www-data:www-data ${WP_ADMIN_DIR}/wp-content/*

	# setting files for index.php, .htaccess, robots.txt
	if [[ -z ${LEN_WP_AD} ]];then
		if [[ -z ${WP_AD} ]];then
			if [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
				chown www-data:www-data ${SITE_DIR}/index.php
				chown root:root ${SITE_DIR}/{.htaccess,robots.txt}
				chmod 644 ${SITE_DIR}/{.htaccess,robots.txt}
			else
				chown www-data:www-data ${SITE_DIR}/index.php
				chown root:root ${SITE_DIR}/{.htaccess,robots.txt}
				chmod 644 ${SITE_DIR}/{.htaccess,robots.txt}
			fi
		fi
	else
		if (( ${LEN_WP_AD} == 0 )) && [[ -z ${WP_AD} ]];then
			chown www-data:www-data ${SITE_DIR}/index.php
			chown root:root ${SITE_DIR}/{.htaccess,robots.txt}
			chmod 644 ${SITE_DIR}/{.htaccess,robots.txt}
		elif (( ${LEN_WP_AD} != 0 )) && [[ -z ${WP_AD} ]]; then
			chown www-data:www-data ${SITE_DIR}/index.php
			chown root:root ${SITE_DIR}/{.htaccess,robots.txt}
			chmod 644 ${SITE_DIR}/{.htaccess,robots.txt}
		else
			if [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
				chown www-data:www-data ${WP_ADMIN_DIR}/index.php
				chown root:root ${WP_ADMIN_DIR}/{.htaccess,robots.txt}
				chmod 644 ${WP_ADMIN_DIR}/{.htaccess,robots.txt}
			else
				chown www-data:www-data ${SITE_DIR}/index.php
				chown root:root ${SITE_DIR}/{.htaccess,robots.txt}
				chmod 644 ${SITE_DIR}/{.htaccess,robots.txt}
			fi
		fi
	fi

	chown -R www-data:www-data ${WP_ADMIN_DIR}/wp-config.php
	
	if [[ ${IS_CUSTOM} == "no" ]];then
		echo "nothing to do."
	else
		chown -R www-data:www-data ${WP_ADMIN_DIR}/wp-content/ ${WP_ADMIN_DIR}/wp-includes/ ${WP_ADMIN_DIR}/wp-admin/
		if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
			chmod 755 ${WP_ADMIN_DIR}/{.htaccess,robots.txt} && chown www-data:www-data ${WP_ADMIN_DIR}/{.htaccess,robots.txt}
		else
			chmod 755 ${SITE_DIR}/{.htaccess,robots.txt} && chown www-data:www-data ${SITE_DIR}/{.htaccess,robots.txt}
		fi
	fi
	
	# remove /var/www/html directory, for not using
	if [[ -d "/var/www/html" ]];then
		rm -rf /var/www/html
	fi

	# remove wp-cli, for security issue
	if [[ -e "/usr/local/bin/wp" ]];then
		rm -rf /usr/local/bin/wp
	fi
}
