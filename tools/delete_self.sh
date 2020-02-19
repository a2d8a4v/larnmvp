#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function _delete_action {
	#delete unnessesary directory
	if [ -d /var/www/html ]; then
		rm -R /var/www/html
	fi
	#delete unnessesary directory
	if [ -d ${YANN_PRO} ]; then
		rm -R ${YANN_PRO}
	fi
	# delete shell script itself
	# rm -- "$0"

	# clean the hitory data in syslog
	if [[ -e "/var/log/syslog" ]]; then
		echo "" > /var/log/syslog
	fi

	# clean the hitory data in auth log
	if [[ -e "/var/log/auth.log" ]]; then
		echo "" > /var/log/auth.log
	fi

	# remove all history for security issues
	HISTORY_TMP="$( echo -e $( find /home -name "*bash_history*" ) $( find /root -name "*bash_history*" ) )"
	for i in ${HISTORY_TMP[@]}; do
		if [[ -e $i ]]; then
			echo "" > $i
		fi
	done
	history -c

	# clean other cache
	if [[ -d "${IT_WHOAMI}/.wp-cli" ]]; then
		rm -rf ${IT_WHOAMI}/.wp-cli
	fi
	if [[ -d "${IT_WHOAMI}/.cache" ]]; then
		rm -rf ${IT_WHOAMI}/.cache
	fi
	if [[ -d "${IT_WHOAMI}/.acme.sh" ]]; then
		rm -rf ${IT_WHOAMI}/.acme.sh
	fi

	# back to the file of this installation at
	local _TMP="$( echo -e $( find /home -name "$(cat ${dir}/VERSION)" ) $( find /root -name "$(cat ${dir}/VERSION)" ) $( find /home -name "__MACOSX" ) $( find /root -name "__MACOSX" ) $( find /home -name "*.zip" ) $( find /root -name "*.zip" ) )"
	for i in ${_TMP[@]}; do
		if [[ -e $i || -d $i ]]; then
			[[ $i == *"$( cat ${dir}/VERSION )"* ]] && rm -rf $i
			[[ $i == *"__MACOSX"* ]] && rm -rf $i
		fi
	done

	
	if [[ $i == *"$( cat ${dir}/VERSION )"* ]]; then
		rm -rf $i
	fi

	# delete all, it is the fast way
	if [[ -d ${dir} ]]; then
		rm -R ${dir}
	fi

	#delete unnessesary directory
	if [ -d ${_INSTALL_DIR} ]; then
		rm -R ${_INSTALL_DIR}
	fi

	# go back to root chroot
	cd /home

	# leave
	exit
}

## -- delete itself
function delete_self {
	if [[ ! -z ${_yannyann_try_start} ]]; then
		if (( ${_yannyann_try_start} == 1 )); then
			_delete_action
		elif (( ${_yannyann_try_start} == 0 )); then
			if [[ ! -z ${_yannyann_delete} ]]; then
				if (( ${_yannyann_delete} == 1 )); then
					_delete_action
				fi
			fi
		fi
	fi
}
