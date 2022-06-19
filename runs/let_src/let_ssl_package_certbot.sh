#!/bin/bash

function let_ssl_package_certbot {
	apt-get -qq install certbot
	if [[ ! -z ${IS_WWW} ]];then
		if (( ${IS_WWW} == 1 )); then
			if [[ -n ${let_use_domain_no_www} ]]; then
				certbot certonly -n --webroot -w /var/www/html/ -d ${website} -d ${let_use_domain_no_www} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
			fi
		fi
	elif [[ ! -z ${ONLY_TWO} ]]; then
		if (( ${ONLY_TWO} == 1 )); then
			if [[ -n ${let_use_domain_www} ]]; then
				certbot certonly -n --webroot -w /var/www/html/ -d ${let_use_domain_www} -d ${website} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
			fi
		fi
	else
		certbot certonly -n --webroot -w /var/www/html/ -d ${website} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
	fi
}
