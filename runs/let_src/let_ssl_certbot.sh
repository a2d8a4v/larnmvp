#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function let_ssl_certbot {
	mkdir -p -v /opt/letsencrypt
	wget https://dl.eff.org/certbot-auto -O /opt/letsencrypt/certbot-auto && chmod a+x /opt/letsencrypt/certbot-auto
	if [[ ! -z ${IS_WWW} ]];then
		if (( ${IS_WWW} == 1 )); then
			if [[ -n ${let_use_domain_no_www} ]]; then
				/opt/letsencrypt/certbot-auto certonly -n --webroot -w /var/www/html/ -d ${website} -d ${let_use_domain_no_www} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
			fi
		fi
	elif [[ ! -z ${ONLY_TWO} ]]; then
		if (( ${ONLY_TWO} == 1 )); then
			if [[ -n ${let_use_domain_www} ]]; then
				/opt/letsencrypt/certbot-auto certonly -n --webroot -w /var/www/html/ -d ${let_use_domain_www} -d ${website} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
			fi
		fi
	else
		/opt/letsencrypt/certbot-auto certonly -n --webroot -w /var/www/html/ -d ${website} --agree-tos -m ${EMAIL} --eff-email --expand --keep-until-expiring --rsa-key-size 4096
	fi
}
