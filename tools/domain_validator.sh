#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function domain_validator {
	local test="$1"
	local test2=$(echo "$1" | sed "s/[^\.0-9A-Za-z\-]/_/g" | sed "s/^[\.]/_/g" | sed "s/\.\./_/g")

	# @https://gist.github.com/guessi/82a73ee7eb2b1216eb9db17bb8d65dd1
	## -- step 1
	DOMAIN_A="^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$"
	DOMAIN_B="^[0-9\p{L}][0-9\p{L}-\.]{1,61}[0-9\p{L}]\.[0-9\p{L}][\p{L}-]*[0-9\p{L}]+$"
	DOMAIN_C="^(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|([a-zA-Z0-9][-_\.a-zA-Z0-9]{1,61}[a-zA-Z0-9]))\.([a-zA-Z]{2,13}|[a-zA-Z0-9-]{2,30}\.[a-zA-Z]{2,3})$"
	DOMAIN_D='(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)'
  	echo "${test}" | grep -P ${DOMAIN_A} | grep -P ${DOMAIN_B} | grep -P ${DOMAIN_C} | grep -P --quiet ${DOMAIN_D}
  	[ $? -eq 0 ] && local step1="good" || local step1="bad"

  	# @https://github.com/QROkes/webinoly/blob/master/lib/sites
  	## -- step 2
  	if [[ "${step1}" == "good" ]]; then
		# Only numerals 0-9, basic Latin letters, both lowercase and uppercase, hyphen.
		[[ ${test} =~ ^[\.0-9A-Za-z\-]+$ ]] || local step2="bad"
		[[ -z ${test2} ]] && local step2="bad"
		
		# Check Lenght
		[[ ${#test} -gt 67 ]] && local step2="bad"
		
		# Can not start or end with a hyphen
		[[ $(echo "${test}" | cut -c-1) == "-" || $(echo "${test}" | rev | cut -c-1) == "-" ]] && local step2="bad"

		# Can not contain two points together and can not start or end with a point
		[[ ${test} == *..* || $(echo "${test}" | cut -c-1) == "." || $(echo "${test}" | rev | cut -c-1) == "." ]] && local step2="bad"
  	fi
  	[[ ${step1} == "good" && -z ${step2} ]] && printf "[yes]" || printf "[no]"
}
