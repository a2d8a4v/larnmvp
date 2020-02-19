#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function check_sftp_port {
	# while read -p "@@ Enter port for SFTP which you like: " sftpport; do
    TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	sftpport=$( echo ${sftpport} | sed 's/^0*//' ) #remove leading zero
    if [[ -z ${sftpport} ]]; then
        echo "You input nothing or should use 'sftpport' as the argument of email, stop."
        leave_exit
    elif [[ ${sftpport} =~ [^[:digit:]] || ${sftpport} == 0 ]]; then
    	echo "Can only input positive integer, stop."
    	leave_exit
    elif [[ ${sftpport} == ${apaport} ]]; then
    	echo "Your cannot use the same integers which you used at port of Apache2, stop."
    	leave_exit
    elif (( ${sftpport} == 80 )) || (( ${sftpport} == 80 )) && [[ ${TEST_CADDY_NGINX} == "nginx" ]]; then
        echo "Port of SFTP couldn't be as 80 because we will let 80 used by port of Varnish, stop."
        leave_exit
    elif (( ${sftpport} == 81 )) || (( ${sftpport} == 81 )) && [[ ${TEST_CADDY_NGINX} == "caddy" ]]; then
        echo "Port of SFTP couldn't be as 81 because we will let 81 used by port of Caddy, stop."
        leave_exit
    elif (( ${sftpport} == 2015 )); then
        echo "Port of SFTP couldn't be as 80 because we will let 80 used by port of Caddy, stop."
        leave_exit
    elif (( ${sftpport} == 443 )); then
    	echo "Port of SFTP couldn't be as 443 because we will let 443 used by port of Nginx, stop."
    	leave_exit
    elif (( ${sftpport} == 3306 )); then
    	echo "Port of Apache2 couldn't be as 3306 because we will let 3306 used by port of MariaDB, stop."
    	leave_exit
    elif (( ${sftpport} == 6379 )); then
    	echo "Port of Apache2 couldn't be as 6379 because we will let 6379 used by port of Redis, stop."
    	leave_exit
    else
        echo "--Your input for port of SFTP is ${sftpport}."
        # break
    fi
	# done
}
