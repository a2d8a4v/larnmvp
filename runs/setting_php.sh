#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_php {
	## -- arguments
	local _phpcgifix_ori=";cgi.fix_pathinfo=1"
	local _phpcgifix_mod="cgi.fix_pathinfo=0"
	## default is 50
	local _php_maxuploads=256
	## default is 60
	local _php_post_maxuploads=260
	local _php_maxexetime=60
	## -- php memory max
	if [ ${MEMORY_H} -le 640 ]; then
		local _php_maxmem=64
	elif [ ${MEMORY_H} -gt 640 -a ${MEMORY_H} -le 1280 ]; then
		local _php_maxmem=128
	elif [ ${MEMORY_H} -gt 1280 -a ${MEMORY_H} -le 2500 ]; then
		local _php_maxmem=192
	elif [ ${MEMORY_H} -gt 2500 -a ${MEMORY_H} -le 3500 ]; then
		local _php_maxmem=256
	elif [ ${MEMORY_H} -gt 3500 -a ${MEMORY_H} -le 4500 ]; then
		local _php_maxmem=320
	elif [ ${MEMORY_H} -gt 4500 -a ${MEMORY_H} -le 8000 ]; then
		local _php_maxmem=384
	elif [ ${MEMORY_H} -gt 8000 ]; then
		local _php_maxmem=448
	fi

	## -- start to optimize
	if [[ -f "/etc/php/${PHP_VER}/fpm/php.ini" ]];then
		## -- fix the security issues
		sed -i 's/'${_phpcgifix_ori}'/'${_phpcgifix_mod}'/g' /etc/php/${PHP_VER}/fpm/php.ini

		#@@@ I think it is not good for server run php with in a long time for security issues, it lets virus can run smoothly
		## change the upload size to 256 MB, but had better equal as 10MB or lower
		sed -i "/upload_max_filesize =/c\upload_max_filesize = ${_php_maxuploads}M" /etc/php/${PHP_VER}/fpm/php.ini
		## fix the excute time to 60 seconds
		sed -i "/max_execution_time =/c\max_execution_time = ${_php_maxexetime}" /etc/php/${PHP_VER}/fpm/php.ini
		## fix the post size to 2 of the upload size, for one post action would not only have a upload file, even with 3 or 4 more files, I think
		sed -i "/post_max_size =/c\post_max_size = ${_php_post_maxuploads}M" /etc/php/${PHP_VER}/fpm/php.ini
		## fix timezone
		sed -i "s/^;date.timezone.*/date.timezone = ${IPADDR_TIMEZONE}/" /etc/php/${PHP_VER}/fpm/php.ini

		sed -i "/memory_limit =/c\memory_limit = ${_php_maxmem}M" /etc/php/${PHP_VER}/fpm/php.ini
		sed -i '/expose_php =/c\expose_php = Off' /etc/php/${PHP_VER}/fpm/php.ini
		sed -i '/max_file_uploads =/c\max_file_uploads = 20' /etc/php/${PHP_VER}/fpm/php.ini
		sed -i '/session.cookie_httponly =/c\session.cookie_httponly = 1' /etc/php/${PHP_VER}/fpm/php.ini
		sed -i "/opcache.memory_consumption=/c\opcache.memory_consumption=${_php_maxmem}" /etc/php/${PHP_VER}/fpm/php.ini
		sed -i '/opcache.interned_strings_buffer=/c\opcache.interned_strings_buffer=8' /etc/php/${PHP_VER}/fpm/php.ini
		sed -i '/opcache.max_accelerated_files=/c\opcache.max_accelerated_files=50000' /etc/php/${PHP_VER}/fpm/php.ini
		sed -i '/opcache.enable_cli=/c\opcache.enable_cli=1' /etc/php/${PHP_VER}/fpm/php.ini
		sed -i '/opcache.enable=/c\opcache.enable=1' /etc/php/${PHP_VER}/fpm/php.ini

		mkdir -p -v /var/log/php/${PHP_VER}
		touch /var/log/php/${PHP_VER}/fpm.log
		sed -i "/error_log =/c\error_log = /var/log/php/${PHP_VER}/fpm.log" /etc/php/${PHP_VER}/fpm/php-fpm.conf
		sed -i '/log_level =/c\log_level = notice' /etc/php/${PHP_VER}/fpm/php-fpm.conf

		sed -i '/pm =/c\pm = ondemand' /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		sed -i '/request_terminate_timeout =/c\request_terminate_timeout = 300' /etc/php/${PHP_VER}/fpm/pool.d/www.conf

		## other's thinking
		if [ ${MEMORY_H} -le 3000 ]; then
			sed -i "s/^pm.max_children.*/pm.max_children = $((${MEMORY_H}/3/20))/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.start_servers.*/pm.start_servers = $((${MEMORY_H}/3/30))/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.min_spare_servers.*/pm.min_spare_servers = $((${MEMORY_H}/3/40))/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.max_spare_servers.*/pm.max_spare_servers = $((${MEMORY_H}/3/20))/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		elif [ ${MEMORY_H} -gt 3000 -a ${MEMORY_H} -le 4500 ]; then
			sed -i "s/^pm.max_children.*/pm.max_children = 50/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.start_servers.*/pm.start_servers = 30/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.min_spare_servers.*/pm.min_spare_servers = 20/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.max_spare_servers.*/pm.max_spare_servers = 50/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		elif [ ${MEMORY_H} -gt 4500 -a ${MEMORY_H} -le 6500 ]; then
			sed -i "s/^pm.max_children.*/pm.max_children = 60/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.start_servers.*/pm.start_servers = 40/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.min_spare_servers.*/pm.min_spare_servers = 30/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.max_spare_servers.*/pm.max_spare_servers = 60/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		elif [ ${MEMORY_H} -gt 6500 -a ${MEMORY_H} -le 8500 ]; then
			sed -i "s/^pm.max_children.*/pm.max_children = 70/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.start_servers.*/pm.start_servers = 50/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.min_spare_servers.*/pm.min_spare_servers = 40/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.max_spare_servers.*/pm.max_spare_servers = 70/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		elif [ ${MEMORY_H} -gt 8500 ]; then
			sed -i "s/^pm.max_children.*/pm.max_children = 100/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.start_servers.*/pm.start_servers = 15/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.min_spare_servers.*/pm.min_spare_servers = 10/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.max_spare_servers.*/pm.max_spare_servers = 80/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		else
			sed -i "s/^pm.max_children.*/pm.max_children = 100/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.start_servers.*/pm.start_servers = 15/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.min_spare_servers.*/pm.min_spare_servers = 10/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
			sed -i "s/^pm.max_spare_servers.*/pm.max_spare_servers = 80/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		fi

		sed -i '/pm.max_requests =/c\pm.max_requests = 500' /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		sed -i '/pm.status_path =/c\pm.status_path = /status' /etc/php/${PHP_VER}/fpm/pool.d/www.conf
		sed -i '/ping.path =/c\ping.path = /ping' /etc/php/${PHP_VER}/fpm/pool.d/www.conf
	fi
	service php${PHP_VER}-fpm restart
}
