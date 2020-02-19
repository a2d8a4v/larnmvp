#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function check_apache2_port {
	# while read -p "@@ Enter Apache2 using port you want: " apaport; do
	# apaport=$((apaport+0)) #problem with 09, 08 ...etc.
	# apaport=`echo ${apaport}|sed 's/^0*//'` #remove leading zero
    TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	apaport=$( echo ${apaport} | sed 's/^0*//' ) #remove leading zero
    if [[ -z ${apaport} ]]; then
        echo "You input nothing or should use 'apaport' as the argument name of apache port, stop."
        leave_exit
    elif [[ ${apaport} =~ [^[:digit:]] || ${apaport} == 0 ]]; then
    	echo "Can only input positive integer, stop."
    	leave_exit
    elif [[ ${apaport} == ${sftpport} ]]; then
        echo "Your cannot use the same integers which you used at port of SFTP, stop."
        leave_exit
    elif (( ${apaport} == 80 )) || (( ${apaport} == 80 )) && [[ ${TEST_CADDY_NGINX} == "nginx" ]]; then
        echo "Port of Apache2 couldn't be as 80 because we will let 80 used by port of Varnish, stop."
        leave_exit
    elif (( ${apaport} == 81 )) || (( ${apaport} == 81 )) && [[ ${TEST_CADDY_NGINX} == "caddy" ]]; then
        echo "Port of Apache2 couldn't be as 81 because we will let 81 used by port of Caddy, stop."
        leave_exit
    elif (( ${apaport} == 2015 )); then
        echo "Port of Apache2 couldn't be as 2015 because we will let 2015 used by port of Caddy, stop."
        leave_exit
    elif (( ${apaport} == 3306 )); then
    	echo "Port of Apache2 couldn't be as 3306 because we will let 3306 used by port of MariaDB, stop."
    	leave_exit
    elif (( ${apaport} == 6379 )); then
    	echo "Port of Apache2 couldn't be as 6379 because we will let 6379 used by port of Redis, stop."
    	leave_exit
    elif (( ${apaport} == 443 )); then
    	echo "Port of Apache2 couldn't be as 443 because we will let 443 used by port of Nginx, stop."
    	leave_exit
    elif (( ${apaport} < 8000 || ${apaport} > 9999 )); then
    	echo "You can do this but Apache2 maybe have conflict with other programs. I advice input a integer between 8000 to 9999, stop."
    	leave_exit
    else
        echo "--Your input for port of Apache is ${apaport}."
        # break
    fi
	# done
}
