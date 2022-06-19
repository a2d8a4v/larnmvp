#!/bin/bash

function check_email {
	# while read -p "@@ Enter your Email: " EMAIL; do
	TEST_EMAIL=$( email_validator "${EMAIL}" )
	if [[ -z ${EMAIL} ]]; then
        echo "You forget to input email or should use 'EMAIL' as the argument of email, stop."
        leave_exit
	elif [[ ${TEST_EMAIL} =~ "[no]" ]]; then
		echo "You have wrong pattern of your email, stop."
		echo "Should be like that: example@example.com"
		leave_exit
	elif [[ ${EMAIL} == "admin@example.com" ]]; then
		echo "You should use a new email but no default, stop."
		leave_exit
	else
		echo "--Your email is ${EMAIL}"
	fi
	#done
}
