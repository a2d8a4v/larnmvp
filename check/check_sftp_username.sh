#!/bin/bash

function check_sftp_username {
	if [[ -z ${ADMNAME} ]];then
		echo "nothing to do."
	else
		USERLIST=$( cut -d: -f1 /etc/passwd )
		# while read -p "@@ Add system user for manage your site: " ADMNAME; do
		TEST_ADMNAME=$( name_validator ${ADMNAME} )
		if [[ ${ADMNAME} =~ [[:blank:]] ]];then
			echo "Can only input without space, stop."
			leave_exit
		elif [[ " $ADMNAME " =~ .*\ ${USERLIST}\ .* ]]; then
			echo "The username $ADMNAME is exsit now, try another one, stop."
			leave_exit
		elif [[ ${TEST_ADMNAME} =~ "[no]" ]]; then
			echo "The username should consist only of letters, digits, underscores, periods, at signs and dashes, and not start with a dash, stop."
			leave_exit
		else
			echo "--Your user name is $ADMNAME"
			#break
		fi
		# done
	fi
}
