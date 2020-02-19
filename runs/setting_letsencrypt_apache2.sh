#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_letsencrypt_run {
	mv -f ${INI}/apache_ini/apafake.conf /etc/apache2/sites-available/000-default.conf
	service apache2 restart

	if [[ ! -d /var/www/html ]];then
		mkdir -p -v /var/www/html
	fi
	if [[ -e "/var/www/html/index.html" ]];then
		rm /var/www/html/index.html
	fi
	mv -f ${INI}/let_ini/index2.php /var/www/html/index.php
	
	#@@@ bug issue for cannot build environment successfully due to bug in pip
	# @https://community.letsencrypt.org/t/certbot-has-problem-setting-up-the-virtual-environment/83787/2
	# @https://github.com/certbot/certbot/issues/6687
	# sed -i 's/virtualenv --no-site-packages/virtualenv --no-download --no-site-packages/' /opt/letsencrypt/certbot-auto
	# /opt/letsencrypt/certbot-auto certonly -n --webroot -w /var/www/html/ -d ${website} --agree-tos -m $EMAIL --eff-email --expand --keep-until-expiring --rsa-key-size 4096 && LET_ERR=0 || LET_ERR=1

	# To check where is the file
	## letencypt ssl can only issue vertification 5 times in one day, therefore we can only try 5 times!
	
	if let_ssl_certbot >> ${dir}/let_tmp.txt;then
		LET_OUT=$( text_contain ${dir}/let_tmp.txt "Congratulations!" )
	elif echo "" > ${dir}/let_tmp.txt && let_ssl_package_certbot >> ${dir}/let_tmp.txt;then
		# @http://www.fengzifz.com/2018/11/15/Ubuntu-18-letsencrypt/
		LET_OUT=$( text_contain ${dir}/let_tmp.txt "Congratulations!" )
	elif echo "" > ${dir}/let_tmp.txt && let_ssl_acme >> ${dir}/let_tmp.txt;then
		# @https://github.com/Neilpang/acme.sh
		LET_OUT=$( text_contain ${dir}/let_tmp.txt "Congratulations!" )
	#@@@ I found that the cert issued by autocert in golang couldn't be used by nginx
	# elif echo "" > ${dir}/let_tmp.txt && let_ssl_golang >> ${dir}/let_tmp.txt;then	
		# LET_OUT=$( text_contain ${dir}/let_tmp.txt "Congratulations!" )
	else
		LET_OUT="[no]"
	fi

	# delete useless file
	rm -R /var/www/html/index.php

	# check is success
	if [[ ${LET_OUT} == "[yes]" ]] ;then
		if [[ -n ${let_use_domain_www} ]]; then
			if [[ -e /etc/letsencrypt/live/${let_use_domain_www} ]]; then
				LET_OUT2=$( text_contain ${dir}/let_tmp.txt "/etc/letsencrypt/live/${let_use_domain_www}" )
			elif [[ -e /etc/letsencrypt/live/${website} ]]; then
				LET_OUT2=$( text_contain ${dir}/let_tmp.txt "/etc/letsencrypt/live/${website}" )
			fi
		elif [[ -n ${let_use_domain_no_www} ]]; then
			if [[ -e /etc/letsencrypt/live/${website} ]]; then
				LET_OUT2=$( text_contain ${dir}/let_tmp.txt "/etc/letsencrypt/live/${website}" )
			elif [[ -e /etc/letsencrypt/live/${domain} ]]; then
				LET_OUT2=$( text_contain ${dir}/let_tmp.txt "/etc/letsencrypt/live/${let_use_domain_no_www}" )
			fi
		fi
		LET_OUT3=$( text_contain ${dir}/let_tmp.txt "fullchain.pem" )
		LET_OUT4=$( text_contain ${dir}/let_tmp.txt "privkey.pem" )
		if [[ ${LET_OUT2} == "[yes]" ]] && [[ ${LET_OUT3} == "[yes]" ]] && [[ ${LET_OUT4} == "[yes]" ]]; then
			# check is really there is fullkey file or not
			if grep ${LET_FULL_KEY} ${dir}/let_tmp.txt; then
				grep ${LET_FULL_KEY} ${dir}/let_tmp.txt > let_tmp1.txt
			elif grep ${LET_FULL_KEY2} ${dir}/let_tmp.txt; then
				grep ${LET_FULL_KEY2} ${dir}/let_tmp.txt > let_tmp1.txt
			fi

			while read line; do
				for (( i=0 ; i>=-${#line} ; i-- )); do
					if (( $i == -${#line} )); then
						LET_FULL_KEY_ERR=1
						break 2
					else
						if (( $i == 0 )); then
							if [[ -e ${line} ]]; then
								echo "${line} a"
								LET_FULL_KEY_ERR=0
								break 2
							fi
						else
							if [[ -e ${line} ]]; then
								echo "${line} b"
								LET_FULL_KEY_ERR=0
								break 2
							fi
						fi
					fi
				done
			done < let_tmp1.txt

			# check is really there is private key file or not
			if grep ${LET_PRI_KEY} ${dir}/let_tmp.txt; then
				grep ${LET_PRI_KEY} ${dir}/let_tmp.txt > let_tmp2.txt
			elif grep ${LET_PRI_KEY2} ${dir}/let_tmp.txt; then
				grep ${LET_PRI_KEY2} ${dir}/let_tmp.txt > let_tmp2.txt
			fi

			while read line; do
				for (( i=0 ; i>=-${#line} ; i-- )); do
					if (( $i == -${#line} )); then
						LET_PRI_KEY_ERR=1
						break 2
					else
						if (( $i == 0 )); then
							if [[ -e ${line} ]]; then
								echo "${line} A"
								LET_PRI_KEY_ERR=0
								break 2
							fi
						else
							if [[ -e ${line} ]]; then
								echo "${line} B"
								LET_PRI_KEY_ERR=0
								break 2
							fi
						fi
					fi
				done
			done < let_tmp2.txt
			#done all
		else
			LET_ERR=1
		fi

		
		# final check
		if [[ ! -z ${LET_PRI_KEY_ERR} ]] && [[ ! -z ${LET_FULL_KEY_ERR} ]]; then
			if (( ${LET_PRI_KEY_ERR} == 0 )) && (( ${LET_FULL_KEY_ERR} == 0 )); then
				LET_ERR=0
			else
				LET_ERR=1
			fi
		else
			LET_ERR=1
		fi
	else
		LET_ERR=1
	fi
}

function setting_letsencrypt_not_run {
	echo "no run."
}

function setting_letsencrypt_apache2 {
	TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	if [[ ${TEST_CADDY_NGINX} == "nginx" ]]; then
		setting_letsencrypt_run
	elif [[ ${TEST_CADDY_NGINX} == "caddy" ]]; then
		setting_letsencrypt_not_run
	else
		setting_letsencrypt_run
	fi
}
