#!/bin/bash

function let_ssl_acme {
	mkdir -p -v /etc/letsencrypt/live/${website}
	curl https://get.acme.sh | sh
	if [[ ! -z ${IS_WWW} ]];then
		if (( ${IS_WWW} == 1 )); then
			if [[ -n ${let_use_domain_no_www} ]]; then
				${IT_WHOAMI}/.acme.sh/acme.sh --issue -d ${website} -d ${let_use_domain_no_www} -w /var/www/html/ \
				--key-file       /etc/letsencrypt/live/${website}/privkey.pem \
				--fullchain-file /etc/letsencrypt/live/${website}/fullchain.pem -k ec-284 --force && echo "
Congratulations!
/etc/letsencrypt/live/${website}/fullchain.pem
/etc/letsencrypt/live/${website}/privkey.pem" >> ${dir}/let_tmp.txt
			fi
		fi
	elif [[ ! -z ${ONLY_TWO} ]]; then
		if (( ${ONLY_TWO} == 1 )); then
			if [[ -n ${let_use_domain_www} ]]; then
				${IT_WHOAMI}/.acme.sh/acme.sh --issue -d ${let_use_domain_www} -d ${website} -w /var/www/html/ \
				--key-file       /etc/letsencrypt/live/${website}/privkey.pem \
				--fullchain-file /etc/letsencrypt/live/${website}/fullchain.pem -k ec-284 --force && echo "
Congratulations!
/etc/letsencrypt/live/${website}/fullchain.pem
/etc/letsencrypt/live/${website}/privkey.pem" >> ${dir}/let_tmp.txt
			fi
		fi
	else
		${IT_WHOAMI}/.acme.sh/acme.sh --issue -d ${website} -w /var/www/html/ \
			--key-file       /etc/letsencrypt/live/${website}/privkey.pem \
			--fullchain-file /etc/letsencrypt/live/${website}/fullchain.pem -k ec-284 --force && echo "
Congratulations!
/etc/letsencrypt/live/${website}/fullchain.pem
/etc/letsencrypt/live/${website}/privkey.pem" >> ${dir}/let_tmp.txt
	fi

	for f in .profile .bashrc; do
		sed -i '/acme/d' ~/${f}
	done
}
