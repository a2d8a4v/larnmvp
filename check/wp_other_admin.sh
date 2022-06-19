#!/bin/bash

function wp_other_admin_no {
	WP_AD=""
	LEN_WP_AD=0
}

function wp_other_admin_yes {
	while read -p "@@ Type your folder name: " WP_AD; do
		NEW_WP_AD=${WP_AD//[^[:alnum:]]/}
		LEN_WP_AD=${#WP_AD}
		LEN_NEW_WP_AD=${#NEW_WP_AD}
		if [[ $WP_AD =~ [[:blank:]] ]];then
			echo "Can only input without space, try again!"
		elif [[ -z ${WP_AD} ]]; then
			while read -p "@@ You input nothing, Do you want to give up? (y/n): " yn2; do
			    case ${yn2} in
			        [Yy]* ) break 2;wp_other_admin_no;;
			        [Nn]* ) break 1;;
			        * ) echo "Please answer yes or no.(y/n)";;
			    esac
			done
		elif (( ${LEN_WP_AD} != ${LEN_NEW_WP_AD} )) ; then
			echo "Can not input special characters."
		else
			echo "--Your user name is ${WP_AD}"
			break
		fi
	done
}

function wp_other_admin {
	while read -p "@@ Do you want to use other folder to install WordPress under the root directory? (y/n): " yn; do
	    case ${yn} in
	        [Yy]* ) wp_other_admin_yes; break;;
	        [Nn]* ) wp_other_admin_no; break;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
}
