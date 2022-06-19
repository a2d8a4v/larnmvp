#!/bin/bash

function install_redis {
	#add-apt-repository -y ppa:chris-lea/redis-server
	#apt-get -qq update && apt-get -qq upgrade
	#apt-get -qq install redis-server php-redis

	wget https://download.redis.io/releases/redis-${REDIS_VER}.tar.gz -O ${dir}/redis.tar.gz && tar xzf ${dir}/redis.tar.gz --directory=${dir}
	mv -f ${dir}/redis-${REDIS_VER} ${dir}/redis
	adduser --system --group --disabled-login redis --no-create-home --home /nonexistent --shell /usr/sbin/nologin --quiet
	usermod -g www-data redis
	# enter in
	cd ${dir}/redis

	make -j$(nproc --all) && make install
	mkdir -p /etc/redis && mv -f ${INI}/redis_ini/redis.conf /etc/redis/
	chown -R redis:root /etc/redis/redis.conf && chmod -R 664 /etc/redis/redis.conf
	mkdir -p /var/run/redis/ && chown -R redis:www-data /var/run/redis/

	mv -f ${INI}/redis_ini/redis.service /lib/systemd/system/ && chown root:root /lib/systemd/system/redis.service && chmod 644 /lib/systemd/system/redis.service

	touch /var/run/redis/redis.pid && chown redis:redis /var/run/redis/redis.pid && chmod 775 /var/run/redis/redis.pid
	mkdir -p /var/lib/redis && chown redis:redis /var/lib/redis && chmod -R 770 /var/lib/redis

	# go back to install root
	cd ${dir}
	
	# make a log file
	touch /var/log/redis.log && chown redis:root /var/log/redis.log && chmod -R 664 /var/log/redis.log
	
	git clone https://github.com/phpredis/phpredis.git ${dir}/phpredis
	# enter in
	cd ${dir}/phpredis
	phpize && ./configure && make -j$(nproc --all) && make install
	# go back to install root
	cd ${dir}

	mv -f ${INI}/redis_ini/redis.ini /etc/php/${PHP_VER}/mods-available/
	chmod 644 /etc/php/${PHP_VER}/mods-available/redis.ini && chown root:root /etc/php/${PHP_VER}/mods-available/redis.ini
	ln -sf /etc/php/${PHP_VER}/mods-available/redis.ini /etc/php/${PHP_VER}/apache2/conf.d/redis.ini
	ln -sf /etc/php/${PHP_VER}/mods-available/redis.ini /etc/php/${PHP_VER}/fpm/conf.d/redis.ini
	ln -sf /etc/php/${PHP_VER}/mods-available/redis.ini /etc/php/${PHP_VER}/cli/conf.d/redis.ini
	# @https://blog.csdn.net/m_nanle_xiaobudiu/article/details/80950957

	# fix the problem with redis
	# @https://natasitpro.wordpress.com/2017/02/07/redis-warning-排除/
	echo -e "net.core.somaxconn=65535\nvm.overcommit_memory=1" >> /etc/sysctl.conf
	echo never > /sys/kernel/mm/transparent_hugepage/enabled
	ulimit -n 10032
	sysctl -p
	
	# update php default session save path
	sed -i '/session.save_handler=/c\session.save_handler=redis' /etc/php/${PHP_VER}/fpm/php.ini
	sed -i '/^;session.save_path=/c\session.save_path=\"tcp://127.0.0.1:6379?auth='${redispasswd}'\"' /etc/php/${PHP_VER}/fpm/php.ini

	systemctl daemon-reload
	systemctl enable redis
	service php${PHP_VER}-fpm restart
	phpenmod redis && service apache2 restart
	service redis start
}
