#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function check_wp_dic_name {
	if [[ -z ${WP_AD} ]];then
		WP_AD=""
		echo "--Your WordPress directory is the same as your website root."
	else
		# while read -p "@@ Add system user for manage your site: " WP_AD; do
		TEST_WP_AD=$( name_validator ${WP_AD} )
		if [[ ${WP_AD} =~ [[:blank:]] ]];then
			echo "Can only input without space, stop."
			leave_exit
		elif [[ ${TEST_WP_AD} =~ "[no]" ]]; then
			echo "The WordPress directory name should only consist of letters, digits, underscores, periods, at signs and dashes, and not start with a dash, stop."
			leave_exit
		elif [[ ${WP_AD} == "admin" ]]; then
			echo "The WordPress directory name should not be like admin, it is too dangerous, stop."
			leave_exit
		else
			echo "--Your WordPress directory name is $WP_AD"
			#break
		fi
		# done
	fi
}
