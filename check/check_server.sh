#!/bin/bash

function check_server {
	if [[ -z ${CADDY_NGINX} ]];then
		CADDY_NGINX="nginx"
		echo "--Using Nginx as the web server as default."
	else
		# while read -p "@@ Add system user for manage your site: " WP_AD; do
		TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
		if [[ ${CADDY_NGINX} =~ [[:blank:]] ]];then
			echo "Can only input without space, stop."
			leave_exit
		elif [[ ${TEST_CADDY_NGINX} == "nginx" ]]; then
			echo "--Using Nginx as web server."
		elif [[ ${TEST_CADDY_NGINX} == "caddy" ]]; then
			echo "--Using Caddy as web server."
		else
			echo "You should only put nginx or caddy, stop."
			leave_exit
			#break
		fi
		# done
	fi
}
