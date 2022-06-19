#!/bin/bash

################################################################################################################################
#
# /*** Import variables first ***/
#
# Here should only set about the argument used by varies installation, not just by only application, 
# only global argument can type here
#
# ## thinking about let everyone make their own config name by them self, but the variables should be fixed.
# ## also, they should get the log file make them can know what does he or she typed.
# ## but if there is a default config file, just start running
# 
################################################################################################################################

function preload_arguments {
	## Varnish 
	TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	if [[ ${TEST_CADDY_NGINX} == "nginx" ]];then
		varnport="80"
	elif [[ ${TEST_CADDY_NGINX} == "caddy" ]];then
		varnport="81"
	else
		varnport="80"
	fi
	# Append the number of Varish port
	echo -e '# The number of Varish port' >> ${scfg}
	echo -e 'varnport="'${varnport}'"' >> ${scfg}

	email_fake_1="$( LC_CTYPE=C tr -dc A-Za-z0-9_\- < /dev/urandom | head -c 14 )@fake1.gmail.com"
	email_fake_2="$( LC_CTYPE=C tr -dc A-Za-z0-9_\- < /dev/urandom | head -c 14 )@fake2.gmail.com"
	# fake email for using
	echo -e '# Fake email 1 for self-vertification ssl key in nginx' >> ${scfg}
	echo -e 'email_fake_1="'${email_fake_1}'"' >> ${scfg}
	echo -e '# Fake email 2 for vertification of yannyann server' >> ${scfg}
	echo -e 'email_fake_2="'${email_fake_2}'"' >> ${scfg}

	## making webroot name
	# under the website full-path structure, should seperate into three type: base directory, site directory, wordpress directory
	IFS=\. read -a array_webrootname <<< "${website}"
	if [[ "${array_webrootname[0]}" != "www" ]] && (( ${#array_webrootname[@]} == 5 )) ; then
		webrdic="${array_webrootname[0]}_${array_webrootname[1]}_${array_webrootname[2]}_${array_webrootname[3]}_${array_webrootname[4]}"
		domain_first="${array_webrootname[0]}"
		domain_middle="${array_webrootname[1]}"
		domain_last="${array_webrootname[2]}"
		domain_lastb="${array_webrootname[3]}"
		domain_lastc="${array_webrootname[4]}"
	elif [[ "${array_webrootname[0]}" != "www" ]] && (( ${#array_webrootname[@]} == 4 )) ; then
		webrdic="${array_webrootname[0]}_${array_webrootname[1]}_${array_webrootname[2]}_${array_webrootname[3]}"
		domain_first="${array_webrootname[0]}"
		domain_middle="${array_webrootname[1]}"
		domain_last="${array_webrootname[2]}"
		domain_lastb="${array_webrootname[3]}"
	elif [[ "${array_webrootname[0]}" != "www" ]] && (( ${#array_webrootname[@]} == 3 )) ; then
		webrdic="${array_webrootname[0]}_${array_webrootname[1]}_${array_webrootname[2]}"
		domain_first="${array_webrootname[0]}"
		domain_middle="${array_webrootname[1]}"
		domain_last="${array_webrootname[2]}"
	elif [[ "${array_webrootname[0]}" != "www" ]] && (( ${#array_webrootname[@]} == 2 )); then
		webrdic="${array_webrootname[0]}_${array_webrootname[1]}"
		domain_middle="${array_webrootname[0]}"
		domain_last="${array_webrootname[1]}"
	else
		if [[ "${array_webrootname[0]}" == "www" ]] && (( ${#array_webrootname[@]} == 3 )); then
			webrdic="${array_webrootname[1]}_${array_webrootname[2]}"
			domain_middle="${array_webrootname[1]}"
			domain_last="${array_webrootname[2]}"
		elif [[ "${array_webrootname[0]}" == "www" ]] && (( ${#array_webrootname[@]} == 4 )); then
			webrdic="${array_webrootname[1]}_${array_webrootname[2]}_${array_webrootname[3]}"
			domain_first="${array_webrootname[1]}"
			domain_middle="${array_webrootname[2]}"
			domain_last="${array_webrootname[3]}"
		fi
	fi
	BASE_DIR="/var/www"
	BASE_DIR_SED_USE=${BASE_DIR//"/"/"\/"} # @https://stackoverflow.com/questions/13210880/replace-one-substring-for-another-string-in-shell-script
	BASE_DIR2_SED_USE=($arg ${BASE_DIR_SED_USE}"\/")
	SITE_DIR="${BASE_DIR}/${webrdic}"
	USER_PUB_DIR="${SITE_DIR}/.login"
	# Append dicretory name of website root to our log file
	echo -e '# The dicretory name of website base' >> ${scfg}
	echo -e 'BASE_DIR="'${BASE_DIR}'"' >> ${scfg}
	echo -e '# The dicretory name of website root' >> ${scfg}
	echo -e 'webrdic="'${webrdic}'"' >> ${scfg}
	echo -e '# The full path of website root' >> ${scfg}
	echo -e 'SITE_DIR="'${SITE_DIR}'"' >> ${scfg}

	## ssl certs get by golang
	GO_SSL_CERT_DIC=${webrdic}

	## -- mariadb, root password
	mariadbpasswd=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	# Append Database name to our log file
	echo -e '# The password of root account in MaraiDB' >> ${scfg}
	echo -e 'mariadbpasswd="'${mariadbpasswd}'"' >> ${scfg}

	## -- Enter redis password
	redispasswd=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	# Append Database name to our log file
	echo -e '# The password of Redis' >> ${scfg}
	echo -e 'redispasswd="'${redispasswd}'"' >> ${scfg}

	## -- enter the admin user name and password of system
	if [[ -z ${ADMNAME} ]];then
		echo ""
	else
		# # Append Database name to our log file
		# echo -e '# The account name in OS system' >> ${scfg}
		# echo -e 'ADMNAME="'${ADMNAME}'"' >> ${scfg}
		ADMNAME_PASWD=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
		# Append Database name to our log file
		echo -e '# The password of account name in OS system' >> ${scfg}
		echo -e 'ADMNAME_PASWD="'${ADMNAME_PASWD}'"' >> ${scfg}
		# sftp setting
		SFTP_G="sftpgroup"
		# Append Database name to our log file
		echo -e '# The name of sftp account group in OS system' >> ${scfg}
		echo -e 'SFTP_G="'${SFTP_G}'"' >> ${scfg}
	fi

	## -- A account can used by us to control the customer server
	# account
	OS_YANN_ACCOUNT=$( LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 10 )
	echo -e '# The account name in OS for us to use' >> ${scfg}
	echo -e 'OS_YANN_ACCOUNT="'${OS_YANN_ACCOUNT}'"' >> ${scfg}
	# password
	OS_YANN_PASSWD=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	echo -e '# Password of account in OS for us to use' >> ${scfg}
	echo -e 'OS_YANN_PASSWD="'${OS_YANN_PASSWD}'"' >> ${scfg}
	## -- password for root account
	OS_ROOT_PASSWD=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	echo -e '# Password for root account in OS for us to use' >> ${scfg}
	echo -e 'OS_ROOT_PASSWD="'${OS_ROOT_PASSWD}'"' >> ${scfg}

	## -- mariadb, username
	ADMDBNAME=$( LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 17 )
	# Append Database name to our log file
	echo -e '# The account name in MaraiDB' >> ${scfg}
	echo -e 'ADMDBNAME="'${ADMDBNAME}'"' >> ${scfg}
	PASSWDDBNAME=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	# Append Database name to our log file
	echo -e '# The password of account in MaraiDB' >> ${scfg}
	echo -e 'PASSWDDBNAME="'${PASSWDDBNAME}'"' >> ${scfg}

	## Decide the domain name and Database name
	IFS=\. read -a array_website <<< "${website}"
	if [[ "${array_website[0]}" != "www" ]] && (( ${#array_website[@]} == 5 )) ; then
		domain=$website
		apache2default="${array_website[0]}_${array_website[1]}_${array_website[2]}_${array_website[3]}_${array_website[4]}.conf"
		varnishdefault="${array_website[0]}_${array_website[1]}_${array_website[2]}_${array_website[3]}_${array_website[4]}.vcl"
		if [[ ${CADDY_NGINX} == "nginx" ]]; then
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]}"_"${array_website[3]}"_"${array_website[4]})
		elif [[ ${CADDY_NGINX} == "caddy" ]]; then
			caddydefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]}"_"${array_website[3]}"_"${array_website[4]})
		else
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]}"_"${array_website[3]}"_"${array_website[4]})
		fi
		dbname="${array_website[0]}_${array_website[1]}_${array_website[2]}_${array_website[3]}_${array_website[4]}_main"
		let_use_domain_www=($arg "www."${array_website[0]}"."${array_website[1]}"."${array_website[2]}"."${array_website[3]}"."${array_website[4]})
	elif [[ "${array_website[0]}" != "www" ]] && (( ${#array_website[@]} == 4 )) ; then
		domain=$website
		apache2default="${array_website[0]}_${array_website[1]}_${array_website[2]}_${array_website[3]}.conf"
		varnishdefault="${array_website[0]}_${array_website[1]}_${array_website[2]}_${array_website[3]}.vcl"
		if [[ ${CADDY_NGINX} == "nginx" ]]; then
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]}"_"${array_website[3]})
		elif [[ ${CADDY_NGINX} == "caddy" ]]; then
			caddydefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]}"_"${array_website[3]})
		else
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]}"_"${array_website[3]})
		fi
		dbname="${array_website[0]}_${array_website[1]}_${array_website[2]}_${array_website[3]}_main"
		let_use_domain_www=($arg "www."${array_website[0]}"."${array_website[1]}"."${array_website[2]}"."${array_website[3]})
	elif [[ "${array_website[0]}" != "www" ]] && (( ${#array_website[@]} == 3 )) ; then
		domain=$website
		apache2default="${array_website[0]}_${array_website[1]}_${array_website[2]}.conf"
		varnishdefault="${array_website[0]}_${array_website[1]}_${array_website[2]}.vcl"
		if [[ ${CADDY_NGINX} == "nginx" ]]; then
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]})
		elif [[ ${CADDY_NGINX} == "caddy" ]]; then
			caddydefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]})
		else
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]}"_"${array_website[2]})
		fi
		dbname="${array_website[0]}_${array_website[1]}_${array_website[2]}_main"
		let_use_domain_www=($arg "www."${array_website[0]}"."${array_website[1]}"."${array_website[2]})
	elif [[ "${array_website[0]}" != "www" ]] && (( ${#array_website[@]} == 2 )) ; then
		ONLY_TWO=1
		domain=$website
		apache2default="${array_website[0]}_${array_website[1]}.conf"
		varnishdefault="${array_website[0]}_${array_website[1]}.vcl"
		if [[ ${CADDY_NGINX} == "nginx" ]]; then
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]})
		elif [[ ${CADDY_NGINX} == "caddy" ]]; then
			caddydefault=($arg ${array_website[0]}"_"${array_website[1]})
		else
			nginxdefault=($arg ${array_website[0]}"_"${array_website[1]})
		fi
		dbname=($arg ${array_website[0]}"_"${array_website[1]}"_main")
		let_use_domain_www=($arg "www."${array_website[0]}"."${array_website[1]})
	else
		IS_WWW=1
		if [[ "${array_webrootname[0]}" == "www" ]] && (( ${#array_webrootname[@]} == 3 )); then
			domain=($arg ${array_website[1]}"."${array_website[2]})
			apache2default="${array_website[1]}_${array_website[2]}.conf"
			varnishdefault="${array_website[1]}_${array_website[2]}.vcl"
			if [[ ${CADDY_NGINX} == "nginx" ]]; then
				nginxdefault=($arg ${array_website[1]}"_"${array_website[2]})
			elif [[ ${CADDY_NGINX} == "caddy" ]]; then
				caddydefault=($arg ${array_website[1]}"_"${array_website[2]})
			else
				nginxdefault=($arg ${array_website[1]}"_"${array_website[2]})
			fi
			dbname=($arg ${array_website[1]}"_"${array_website[2]}"_main")
			let_use_domain_no_www=($arg ${array_website[1]}"."${array_website[2]})
		elif [[ "${array_webrootname[0]}" == "www" ]] && (( ${#array_webrootname[@]} == 4 )); then
			domain=($arg ${array_website[1]}"."${array_website[2]}"."${array_website[3]})
			apache2default="${array_website[1]}_${array_website[2]}_${array_website[3]}.conf"
			varnishdefault="${array_website[1]}_${array_website[2]}_${array_website[3]}.vcl"
			if [[ ${CADDY_NGINX} == "nginx" ]]; then
				nginxdefault=($arg ${array_website[1]}"_"${array_website[2]}"_"${array_website[3]})
			elif [[ ${CADDY_NGINX} == "caddy" ]]; then
				caddydefault=($arg ${array_website[1]}"_"${array_website[2]}"_"${array_website[3]})
			else
				nginxdefault=($arg ${array_website[1]}"_"${array_website[2]}"_"${array_website[3]})
			fi
			dbname=($arg ${array_website[1]}"_"${array_website[2]}"_"${array_website[3]}"_main")
			let_use_domain_no_www=($arg ${array_website[1]}"."${array_website[2]}"."${array_website[3]})
		fi
	fi
	# Append Database name to our log file
	dbname=${dbname//$badString/$goodString}
	echo -e '# The Database Table name' >> ${scfg}
	echo -e 'dbname="'${dbname}'"' >> ${scfg}
	# Append Nginx file name to our log file
	echo -e '# The Nginx config file name' >> ${scfg}
	echo -e 'nginxdefault="'${nginxdefault}'"' >> ${scfg}
	# Append Apache file name to our log file
	echo -e '# The Apache file name' >> ${scfg}
	echo -e 'apache2default="'${apache2default}'"' >> ${scfg}
	# Append Varnish file name to our log file
	echo -e '# The Varnish config file name' >> ${scfg}
	echo -e 'varnishdefault="'${varnishdefault}'"' >> ${scfg}

	# phpMyAdmin database password
	PMA_APP_NAME=$( LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 10 )
	# do not use equal =
	PMA_APP_PASS=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	# Append Database name to our log file
	echo -e '# The account name in phpMyAdmin' >> ${scfg}
	echo -e 'PMA_APP_NAME="'${PMA_APP_NAME}'"' >> ${scfg}
	echo -e '# The password of account in phpMyAdmin' >> ${scfg}
	echo -e 'PMA_APP_PASS="'${PMA_APP_PASS}'"' >> ${scfg}

	# Caddy protect some files
	CAD_APP_NAME=$( LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 10 )
	# do not use equal =
	CAD_APP_PASS=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	# Append Database name to our log file
	TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	if [[ ${TEST_CADDY_NGINX} == "nginx" ]];then
		echo ""
	elif [[ ${TEST_CADDY_NGINX} == "caddy" ]];then
		echo -e '# The name in Caddy' >> ${scfg}
		echo -e 'CAD_APP_NAME="'${CAD_APP_NAME}'"' >> ${scfg}
		echo -e '# The password in Caddy' >> ${scfg}
		echo -e 'CAD_APP_PASS="'${CAD_APP_PASS}'"' >> ${scfg}
	else
		echo ""
	fi

	# Random password for WordPress user
	WPUSER=$( LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 10 )
	# do not use equal =
	WPASSWD=$( LC_CTYPE=C tr -dc A-Za-z0-9_\@\#\$\%\^\&\*\-\+ < /dev/urandom | head -c 20 )
	# Append Database name to our log file
	echo -e '# The account name in WordPress' >> ${scfg}
	echo -e 'WPUSER="'${WPUSER}'"' >> ${scfg}
	echo -e '# The password of account in WordPress' >> ${scfg}
	echo -e 'WPASSWD="'${WPASSWD}'"' >> ${scfg}

	# let ssl
	if [[ ! -z ${ONLY_TWO} ]]; then
		if (( ${ONLY_TWO} == 1 )); then
			LET_D=${let_use_domain_www}
		fi
	elif [[ ! -z ${IS_WWW} ]]; then
		if (( ${IS_WWW} == 1 ));then
			LET_D=${website}
		else
			LET_D=${let_use_domain_www}
		fi
	fi

	LET_FULL_KEY2="^[[:space:]]*\/etc\/*[letsencrypt]*\/*[live]*\/*[${website}]*\-[0-9]*\/*fullchain*.*pem"
	LET_PRI_KEY2="^[[:space:]]*\/etc\/*[letsencrypt]*\/*[live]*\/*[${website}]*\-[0-9]*\/*privkey*.*pem"
	LET_FULL_KEY="^[[:space:]]*\/etc\/*[letsencrypt]*\/*[live]*\/*[${website}]*\/*fullchain*.*pem"
	LET_PRI_KEY="^[[:space:]]*\/etc\/*[letsencrypt]*\/*[live]*\/*[${website}]*\/*privkey*.*pem"

	# WordPress dicretory
	LEN_WP_AD=${#WP_AD}
	if [[ -z ${LEN_WP_AD} ]];then
		if [[ -z ${WP_AD} ]];then
			WP_AD=""
			WP_AD2=""
			WP_AD_SEDUSE=""
			WP_AD2_SEDUSE=""
			WP_ADMIN_DIR="${BASE_DIR}/${webrdic}"
			echo -e '# The dicretory name of WordPress installed' >> ${scfg}
			echo -e 'WP_AD=""' >> ${scfg}
			echo -e '# The full path of WordPress installed' >> ${scfg}
			echo -e 'WP_ADMIN_DIR="'${WP_ADMIN_DIR}'"' >> ${scfg}
		fi
	else
		if (( ${LEN_WP_AD} == 0 )) && [[ -z ${WP_AD} ]];then
			WP_AD=""
			WP_AD2=""
			WP_AD_SEDUSE=""
			WP_AD2_SEDUSE=""
			WP_ADMIN_DIR="${BASE_DIR}/${webrdic}"
			echo -e '# The dicretory name of WordPress installed' >> ${scfg}
			echo -e 'WP_AD=""' >> ${scfg}
			echo -e '# The full path of WordPress installed' >> ${scfg}
			echo -e 'WP_ADMIN_DIR="'${WP_ADMIN_DIR}'"' >> ${scfg}
		elif (( ${LEN_WP_AD} != 0 )) && [[ -z ${WP_AD} ]]; then
			WP_AD="" # for modify ini should use this argument
			WP_AD2=""
			WP_AD_SEDUSE=""
			WP_AD2_SEDUSE=""
			WP_ADMIN_DIR="${BASE_DIR}/${webrdic}"
			echo -e '# The dicretory name of WordPress installed' >> ${scfg}
			echo -e 'WP_AD=""' >> ${scfg}
			echo -e '# The full path of WordPress installed' >> ${scfg}
			echo -e 'WP_ADMIN_DIR="'${WP_ADMIN_DIR}'"' >> ${scfg}
		else
			# ${WP_AD} will add "/" forwording for using, don't worry
			WP_AD_SEDUSE=($arg "\/"${WP_AD})
			WP_AD2_SEDUSE=($arg "\/"${WP_AD}"\/")
			WP_ADMIN_DIR="${BASE_DIR}/${webrdic}/${WP_AD}"
			echo -e '# The dicretory name of WordPress installed' >> ${scfg}
			echo -e 'WP_AD="'${WP_AD}'"' >> ${scfg}
			echo -e '# The full path of WordPress installed' >> ${scfg}
			echo -e 'WP_ADMIN_DIR="'${WP_ADMIN_DIR}'"' >> ${scfg}
		fi
	fi

	# WordPress prefix
	WP_PREFIX_RANDOM=($arg "wp_"$( LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 10 ))
	echo -e '# The talbe prefix of WordPress' >> ${scfg}
	echo -e 'WP_PREFIX_RANDOM="'${WP_PREFIX_RANDOM}'"' >> ${scfg}

	## -- nginx config
	# CORE_U=$(( $( grep processor /proc/cpuinfo | wc -l ) * 2 ))
	CORE_U="auto"
	ULIMIT_U=$(( $( ulimit -n ) * 4 ))

	## -- perl version
	PERL_V=$(perl -e 'print "$^V\n"' | cut -f 2 -d v)

	## -- OS information
	SWAP_FILE="/swapfile"
	#@@@ if swapfile exsit and it will lead to wrong
	while :;do [ -e "${SWAP_FILE}" ] && { SWAP_FILE="${SWAP_FILE}$( LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 1 )"; break 1; } || { break 1; } ; done
	MEMORY_H_KB=$(grep MemTotal /proc/meminfo | cut -f 2 -d ':' | tr -d ' ' | cut -f 1 -d 'k')
	MEMORY_H=$((${MEMORY_H_KB}/1024))
	MEMORY_F_MB=$(free -m | awk '/Mem:/{print $2}')
	SWPA_H_KB=$(grep SwapTotal /proc/meminfo | cut -f 2 -d ':' | tr -d ' ' | cut -f 1 -d 'k')
	SWAP_H=$((${SWPA_H_KB}/1024))
	SWAP_F_MB=$(free -m | awk '/Swap:/{print $2}')
	DISK_MAXIMUN_MB=$(df -k | awk '$6 ~ /^\/$/{print $2}' | echo $(($(xargs)/1048)) )
	DISK_USED_MB=$(df -k | awk '$6 ~ /^\/$/{print $3}' | echo $(($(xargs)/1024)) )
	DISK_AVAI_MB=$(df -k | awk '$6 ~ /^\/$/{print $4}' | echo $(($(xargs)/1024)) )
	DISK_PERCEN_MB=$(df -k | awk '$6 ~ /^\/$/{print $5}')
	## -- Memory, swap and core
	[ ${MEMORY_H} -le 640 ] && THREAD=1 || THREAD=$(nproc --all)
	# THREAD=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)
	if [[ ${MEMORY_H} -le 1024 ]]; then
		[[ ${SWAP_H} -eq ${SWAP_F_MB} ]] && SWAP_N_SIZE=$( echo "(${MEMORY_H}*2 - ${SWAP_F_MB})"|bc|awk -vn=$(xargs) 'BEGIN{ print (n * '${MEMORY_F_MB}'/'${MEMORY_H}')}' | math_ceil $(xargs)) ||
		SWAP_N_SIZE=$( echo "(${MEMORY_H}*2 - ${SWAP_F_MB})"|bc|awk -vn=$(xargs) 'BEGIN{ print (n * '${MEMORY_F_MB}'/'${MEMORY_H}' * (1 - '${SWAP_F_MB}'/'${SWAP_H}'))}' | math_ceil $(xargs))
	elif [[ ${MEMORY_H} -le 6144 ]]; then
		[[ ${SWAP_H} -eq ${SWAP_F_MB} ]] && SWAP_N_SIZE=$( echo "(${MEMORY_H} - ${SWAP_F_MB})"|bc|awk -vn=$(xargs) 'BEGIN{ print (n * 0.4)}' | math_ceil $(xargs)) ||
		SWAP_N_SIZE=$( echo "(${MEMORY_H} - ${SWAP_F_MB})"|bc|awk -vn=$(xargs) 'BEGIN{ print (n * 0.5 * (1 - '${SWAP_F_MB}'/'${SWAP_H}'))}' | math_ceil $(xargs))
	elif [[ ${MEMORY_H} -le 12288 ]]; then
		SWAP_N_SIZE="3072"
	elif [[ ${MEMORY_H} -le 16384 ]]; then
		SWAP_N_SIZE="4096"
	elif [[ ${MEMORY_H} -le 24576 ]]; then
		SWAP_N_SIZE="5120"
	elif [[ ${MEMORY_H} -le 32768 ]]; then
		SWAP_N_SIZE="6144"
	elif [[ ${MEMORY_H} -le 65536 ]]; then
		SWAP_N_SIZE="8192"
	elif [[ ${MEMORY_H} -le 131072 ]]; then
		SWAP_N_SIZE="11264"
	elif [[ ${MEMORY_H} -gt 131072 ]]; then
		SWAP_N_SIZE="15360"
	else
		SWAP_N_SIZE="0"
	fi
	## -- if disk is too small, reduce the swap size
	[[ $((${DISK_MAXIMUN_MB}/${SWAP_N_SIZE})) -lt 10 ]] && [[ ${SWAP_N_SIZE} -ne "0" ]] && SWAP_N_SIZE="1024"

	# openssl-server config file path
	if (( ${SSHD_GO} == 0 )) && [[ -e "/etc/sshd_config" ]]; then
		sshd_config_path="/etc/sshd_config"
	elif (( ${SSHD_GO} == 1 )) && [[ -e "/etc/ssh/sshd_config" ]]; then
		sshd_config_path="/etc/ssh/sshd_config"
	else
		sshd_config_path="/etc/ssh/sshd_config"
	fi
}
