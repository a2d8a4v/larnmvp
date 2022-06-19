#!/bin/bash

function mariadb_root_passwd {
	while read -p "@@ Enter password of root account in MariaDB: " mariadbpasswd;do
		if [[ ${mariadbpasswd} =~ [[:blank:]] ]];then
			echo "Can only input without space, try do it again!"
		elif [[ -z ${mariadbpasswd} ]]; then
			echo "You input nothing, do it again!"
		else
			echo "--Your password of root account in MariaDB is ${mariadbpasswd}"
			break
		fi
	done
}
