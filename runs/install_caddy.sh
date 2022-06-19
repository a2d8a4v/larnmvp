#!/bin/bash

function install_caddy_run {
	# @https://computingforgeeks.com/install-caddy-web-server-on-an-ubuntu-18-04-with-lets-encrypt-ssl/
	# @https://computingforgeeks.com/host-wordpress-website-with-caddy-web-server/
	# @https://onebox.site/archives/130.html
	# @https://onebox.site/archives/489.html
	# @https://caddyserver.com/download
	# @https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-caddy-on-ubuntu-16-04
	# @https://github.com/caddyserver/examples/blob/master/wordpress/Caddyfile
	# @https://gist.github.com/mwpastore/f42f6f1309a7b067519f4c08e18b0b6a
	# @https://blog.caesarchi.com/2017/04/06/nginx_caddy_cloudflare/

	## -- install caddy server
	curl https://getcaddy.com | bash -s personal http.awses,http.awslambda,http.cache,http.cgi,http.cors,http.datadog,http.expires,http.filebrowser,http.filter,http.forwardproxy,http.geoip,http.git,http.gopkg,http.grpc,http.ipfilter,http.jwt,http.locale,http.login,http.mailout,http.minify,http.nobots,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,http.restic,http.s3browser,http.upload,http.webdav,tls.dns.auroradns,tls.dns.azure,tls.dns.cloudflare,tls.dns.cloudxns,tls.dns.digitalocean,tls.dns.dnsimple,tls.dns.dnsmadeeasy,tls.dns.dnspod,tls.dns.dyn,tls.dns.exoscale,tls.dns.gandi,tls.dns.gandiv5,tls.dns.godaddy,tls.dns.googlecloud,tls.dns.lightsail,tls.dns.linode,tls.dns.namecheap,tls.dns.ns1,tls.dns.otc,tls.dns.ovh,tls.dns.powerdns,tls.dns.rackspace,tls.dns.rfc2136,tls.dns.route53,tls.dns.vultr,docker,hook.service
	# at first it shows like this: -rwxr-xr-x 1 yannyann_ntu_200 google-sudoers 78422984 Mar 13 22:46 /usr/local/bin/caddy*
	adduser --system --group --disabled-login caddy --no-create-home --shell /bin/nologin --quiet || echo "a"
	usermod -g www-data caddy
	chown root:root /usr/local/bin/caddy && chmod 755 /usr/local/bin/caddy

	## -- setting caddy
	# let caddy can use network
	setcap 'cap_net_bind_service=+eip' /usr/local/bin/caddy

	# setting www-data
	# groupadd -g 33 www-data
	# useradd \
 #  	-g www-data \
 #  	--home-dir ${BASE_DIR} \
 #  	--shell /usr/sbin/nologin \
 # 	--system --uid 33 www-data

 	# create directories
	mkdir -p -v /etc/caddy && chown -R root:www-data /etc/caddy
	mkdir -p -v /etc/ssl/caddy && chown -R root:www-data /etc/ssl/caddy && chmod 770 /etc/ssl/caddy
	# mkdir -p -v ${BASE_DIR} && chown www-data:www-data ${BASE_DIR} && chmod 755 ${BASE_DIR}

	# create log files
	mkdir -p -v ${BASE_DIR}/${webrdic}/log/caddy
	echo "" | tee ${BASE_DIR}/${webrdic}/log/caddy/access.log
	echo "" | tee ${BASE_DIR}/${webrdic}/log/caddy/error.log
	chown -R root:www-data ${BASE_DIR}/${webrdic}/log
	chmod -R 700 ${BASE_DIR}/${webrdic}/log

	# copy important files let we can use on start-up
	cp -f ${INI}/caddy_ini/caddy.service /lib/systemd/system/caddy.service
	chown root:root /lib/systemd/system/caddy.service && chmod 644 /lib/systemd/system/caddy.service

	# copy setting file for caddy
	cp -f ${INI}/caddy_ini/caddyfile /etc/caddy/caddyfile
	chown root:root /etc/caddy/caddyfile && chmod 644 /etc/caddy/caddyfile

	# ufw setting
	ufw allow http
	ufw allow https

	## -- The first run and apply for ssl certification automatically
	systemctl daemon-reload
	systemctl enable caddy.service
	service caddy start
}

function install_caddy_no_run {
	echo "no run."
}

function install_caddy {
	## -- install nginx from source or google verison
	TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	if [[ ${TEST_CADDY_NGINX} == "nginx" ]]; then
		install_caddy_no_run
	elif [[ ${TEST_CADDY_NGINX} == "caddy" ]]; then
		install_caddy_run
	else
		install_caddy_no_run
	fi
}
