#!/bin/bash

function mariadb_username {
	while read -p "@@ Add user for manage your site in MariaDB: " ADMDBNAME; do
		TEST_ADMDBNAME=$( name_validator ${ADMDBNAME} )
		if [[ ${ADMDBNAME} =~ [[:blank:]] ]];then
			echo "Can only input without space, try do it again!"
		elif [[ -z ${ADMDBNAME} ]]; then
			echo "You input nothing, do it again!"
		elif [[ ${TEST_ADMDBNAME} =~ "[no]" ]]; then
			echo "The username should consist only of letters, digits, underscores, periods, at signs and dashes, and not start with a dash."
		else
			echo "--Your user name is ${ADMDBNAME}"
			break
		fi
	done
}
