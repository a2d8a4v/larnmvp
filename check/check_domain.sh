#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function check_domain {
	# while read -p "@@ Enter your domain: " website; do
	# TEST_DOMAIN=`echo $website | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)'`
	TEST_DOMAIN=$( domain_validator "${website}" )
	if [[ -z ${website} ]]; then
		echo "You input nothing or should use 'website' as the argument of website, stop."
		leave_exit
	elif [[ ${TEST_DOMAIN} =~ "[no]" ]]; then
		echo "You have a wrong pattern of your domain input."
		echo "Should be something like this: www.example.com"
		leave_exit
	else
		echo "--Your website is ${website}"
		# break
	fi
}
