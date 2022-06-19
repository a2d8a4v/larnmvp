#!/bin/bash

function enter_admin_passwd {
	while read -p "@@ Your password for system administrator to manage site: " ADMNAME_PASWD; do
		if [[ ${ADMNAME_PASWD} =~ [[:blank:]] ]];then
			echo "Can only input without space, try do it again!"
		elif [[ -z ${ADMNAME_PASWD} ]]; then
			echo "You input nothing, do it again!"
		else
			echo "--Your password of administrator is ${ADMNAME_PASWD}"
			break
		fi
	done
}
