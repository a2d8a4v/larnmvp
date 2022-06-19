#!/bin/bash

function setting_nginx_run {
	# delete nginx default
	if ls /etc/nginx/*.default >/dev/null 2>&1;then
		rm -rf /etc/nginx/*.default
	fi

	if [[ -f /etc/nginx/conf.d/default.conf ]];then
		rm -rf /etc/nginx/conf.d/default.conf
	fi

	## -- config nginx conf
	mv -f ${INI}/nginx_ini/nginx.conf /etc/nginx/ && chown root:root /etc/nginx/nginx.conf && chmod 644 /etc/nginx/nginx.conf

	mkdir -p -v /etc/nginx/modules
	ln -s /usr/lib64/nginx/modules /etc/nginx/modules
	adduser --system --home /nonexistent --shell /bin/false --no-create-home --disabled-login --disabled-password --gecos "nginx user" --group nginx || echo "a"
	mkdir -p /etc/nginx/{conf.d,snippets,sites-available,sites-enabled}
	mkdir -p -v /var/lib/nginx/{body,fastcgi,proxy,scgi,uwsgi} && chmod 700 /var/lib/nginx/* && chown nginx:root /var/lib/nginx/*
	mv -f ${INI}/nginx_ini/fastcgi-php.conf /etc/nginx/snippets/
	chmod 700 /etc/nginx/snippets/*.* && chown nginx:root /etc/nginx/snippets/*.*

	if [[ ! -e /etc/nginx/fastcgi.conf ]];then
		cp -f ${INI}/nginx_ini/fastcgi.conf /etc/nginx/
	fi

	mv -f ${INI}/nginx_ini/nginx_d /etc/init.d/nginx
	chmod +x /etc/init.d/nginx && update-rc.d -f nginx defaults

	mv -f ${INI}/nginx_ini/nginx.service /lib/systemd/system/
	chmod 644 /lib/systemd/system/nginx.service && chown root:root /lib/systemd/system/nginx.service
	# ln -s /lib/systemd/system/nginx.service /etc/systemd/system/nginx.service
	# it has the same effect like "systemctl enable nginx"
	
	systemctl daemon-reload
	systemctl enable nginx
	service nginx start

	ufw allow OpenSSH
	mv -f ${INI}/nginx_ini/nginx_ufw /etc/ufw/applications.d/nginx

	if (( $LET_ERR == 1 ));then
		# echo $LET_ERR
		cp -f ${INI}/nginx_ini/default2 /etc/nginx/sites-available/${nginxdefault}
	else
		cp -f ${INI}/nginx_ini/${nginxdefault} /etc/nginx/sites-available/
	fi

	chmod -R 644 /etc/nginx/sites-available/${nginxdefault}
	chown -R root:root /etc/nginx/sites-available/${nginxdefault}
	ln -s /etc/nginx/sites-available/${nginxdefault} /etc/nginx/sites-enabled/${nginxdefault}

	# log monitor
	mkdir -p -v ${SITE_DIR}/log/nginx
	echo "" | tee ${SITE_DIR}/log/nginx/access.log
	echo "" | tee ${SITE_DIR}/log/nginx/error.log
	chown -R root:www-data ${SITE_DIR}/log
	chmod -R 700 ${SITE_DIR}/log

	mv -f ${INI}/nginx_ini/nginx_log /etc/logrotate.d/nginx

	mkdir -p -v /etc/nginx/ssl/
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=TW/ST=Taiwan/L=Taipei/O=${domain_middle}_${domain_last}/CN=${website}/emailAddress=${email_fake_1}" -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
	
	if [[ ${IS_CUSTOM} == "no" ]];then
		echo "nothing to do."
	else
		echo "nothing to do."
		# openssl dhparam -out dhparams.pem 4096 > $dnuloger
		# mv ./dhparams.pem /etc/nginx/ssl/
		# chown www-data:www-data /etc/nginx/ssl/dhparams.pem
		# chmod 400 /etc/nginx/ssl/dhparams.pem
	fi

	service nginx restart || cp -f ${INI}/nginx_ini/default2 /etc/nginx/sites-available/${nginxdefault} && service nginx restart #even restart with wrong not make script shutdown
}

function setting_nginx_no_run {
	echo "no run."
}

function setting_nginx {
	TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	if [[ ${TEST_CADDY_NGINX} == "nginx" ]]; then
		setting_nginx_run
	elif [[ ${TEST_CADDY_NGINX} == "caddy" ]]; then
		setting_nginx_no_run
	else
		setting_nginx_run
	fi
}
