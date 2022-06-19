#!/bin/bash

function crea_config {
	#while read -p "@@ Enter your new config file name: " FILE_NAME; do
		FILE_NAME="installmod"
		NEW_FILE_NAME=${FILE_NAME//[^[:alnum:]]/}
		LEN_FILE_NAME=${#FILE_NAME}
		LEN_NEW_FILE_NAME=${#NEW_FILE_NAME}
		if [[ -z ${FILE_NAME} ]]; then
	        echo "You input nothing, do it again!"
		elif (( ${LEN_FILE_NAME} != ${LEN_NEW_FILE_NAME} )); then
			echo "Can not input special characters."
		else
			echo "--The name of new config file is ${NEW_FILE_NAME}.conf"
			break
		fi
	#done
}
