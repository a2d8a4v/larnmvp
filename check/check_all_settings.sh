#!/bin/bash

function check_all_settings {
	if [ -e "conf/install.conf" ]; then
		# import arguments typed by users
		cp -v $conf/install.conf $conf/install_mod.conf > /dev/null 2>&1
		scfg=($arg $conf/install_mod.conf)
		. ${scfg}

		## check if all the arguments are exist or not
		#- if all are correct and completely, pass
		#- if some are correct but are not quantity in equal, create variables and values by myself
		#- if some variables are not correct, reproduce by myself

		while read -e -r -s -n 1 -t 10 -p "### The script will continue in 10s. but if you want to disrupt larnmvp, please type 's'. " STOP_KEY;do
			if [[ ${STOP_KEY} = [sS] ]];then
				while read -p "@@ Do you really want to leave larnmvp? (y/n): " yn0; do
				    case ${yn0} in
				        [Yy]* ) leave_exit;; #leave the whole script
				        [Nn]* ) break 1;;
				        * ) echo "Please answer yes or no.(y/n)";;
				    esac
				done
			fi
		done

		echo ""
		echo "### Continue and checking all the settings are correct."

		## -- Check email
		check_email
		sleep 1s

		## -- Check your domain
		check_domain
		sleep 1s

		## -- Check Using Caddy sever or Nginx server
		check_server
		sleep 1s

		## -- Check port of apache2
		check_apache2_port
		sleep 1s

		## -- Check port of sftp username
		check_sftp_username
		sleep 1s

		## -- Check WordPress directory name
		check_wp_dic_name
		sleep 1s

		TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
		if [[ ${TEST_CADDY_NGINX} == "nginx" ]];then
			## -- Check Varnish
			echo "@@ port of Varnish can only be as 80."
			echo "--Your input for port of Varnish is 80."
			sleep 1s

			## -- Check Nginx
			echo "@@ port of Nignx can only be as 443 for SSL connect."
			echo "--Your input for port of Nignx is 443."
			sleep 1s
			# 443 is written in config file.
		elif [[ ${TEST_CADDY_NGINX} == "caddy" ]];then
			## -- Check Varnish
			echo "@@ port of Varnish can only be as 81."
			echo "--Your input for port of Varnish is 81."
			sleep 1s

			## -- Check Nginx
			echo "@@ port of Caddy can only be as 443 for SSL connect."
			echo "--Your input for port of Caddy is 443 and 80."
			sleep 1s
			# 443 is written in config file.
		else
			## -- Check Varnish
			echo "@@ port of Varnish can only be as 80."
			echo "--Your input for port of Varnish is 80."
			sleep 1s

			## -- Check Nginx
			echo "@@ port of Nignx can only be as 443 for SSL connect."
			echo "--Your input for port of Nignx is 443."
			sleep 1s
			# 443 is written in config file.
		fi

		## -- Check port of sftp
		check_sftp_port
		sleep 1s

		echo ""
		echo "### Start running the script."
	else
		clear
		echo "
		Please re-clone all the files from Github. 
		Some important files are not exsit.
		Please type in terminal: git clone https://github.com/a2d8a4v/larnmvp.git
		"
		#leave the whole script
		exit 2
	fi
}
