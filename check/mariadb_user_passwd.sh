#!/bin/bash

function mariadb_user_passwd {
	while read -p "@@ Enter password of account in MariaDB: " PASSWDDBNAME;do
		if [[ ${PASSWDDBNAME} =~ [[:blank:]] ]];then
			echo "Can only input without space, try do it again!"
		elif [[ -z ${PASSWDDBNAME} ]]; then
			echo "You input nothing, do it again!"
		else
			echo "--Your password of $ADMNAME account in MariaDB is ${PASSWDDBNAME}"
			break
		fi
	done
}
