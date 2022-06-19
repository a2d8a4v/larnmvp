#!/bin/bash

function let_ssl_certbot {
	mkdir -p -v /opt/letsencrypt && wget https://dl.eff.org/certbot-auto -O /opt/letsencrypt/certbot-auto && chmod a+x /opt/letsencrypt/certbot-auto
	apt-get install -qq snapd && snap install core && sudo snap refresh core && snap install --classic certbot
	if [[ -f "/usr/bin/certbot" ]];then
		rm -rf /usr/bin/certbot
	fi
	ln -s /snap/bin/certbot /usr/bin/certbot
	
	if [[ ! -z ${IS_WWW} ]];then
		if (( ${IS_WWW} == 1 )); then
			if [[ -n ${let_use_domain_no_www} ]]; then
				/usr/bin/certbot certonly -n --webroot -w /var/www/html/ -d ${website} -d ${let_use_domain_no_www} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
			fi
		fi
	elif [[ ! -z ${ONLY_TWO} ]]; then
		if (( ${ONLY_TWO} == 1 )); then
			if [[ -n ${let_use_domain_www} ]]; then
				/usr/bin/certbot certonly -n --webroot -w /var/www/html/ -d ${let_use_domain_www} -d ${website} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
			fi
		fi
	else
		/usr/bin/certbot certonly -n --webroot -w /var/www/html/ -d ${website} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
	fi
}
