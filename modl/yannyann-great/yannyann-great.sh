#!/bin/bash

#########################################################################################################################
## Great domain
## Version : 0.0.1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website   : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

## -- Referance block
#########################################################################################################################
##
##
#########################################################################################################################

function yannyann_delete_action {
	# delete shell script itself
	rm -- "$0"

	# clean the hitory data in syslog
	[ -e "/var/log/syslog" ] && echo "" > /var/log/syslog
	# clean the hitory data in auth log
	[ -e "/var/log/auth.log" ] && echo "" > /var/log/auth.log
	# remove all history for security issues
	local HISTORY_TMP="$( echo -e $( find /home -name "*bash_history*" ) $( find /root -name "*bash_history*" ) )"
	for i in ${HISTORY_TMP[@]}; do
		[ -e $i ] && echo "" > $i
	done
	history -c

	# back to the file of this installation at
	local _TMP="$( echo -e $( find /home -name "$(cat ${dir}/VERSION)" ) $( find /root -name "$(cat ${dir}/VERSION)" ) $( find /home -name "__MACOSX" ) $( find /root -name "__MACOSX" ) $( find /home -name "*.zip" ) $( find /root -name "*.zip" ) )"
	for i in ${_TMP[@]}; do
		if [[ -e $i || -d $i ]]; then
			[[ $i == *"$( cat ${dir}/VERSION )"* ]] && rm -rf $i
			[[ $i == *"__MACOSX"* ]] && rm -rf $i
		fi
	done

	# delete all, it is the fast way
	[ -d ${dir} ] && rm -R ${dir}

	# go back to root chroot
	cd /home

	# leave
	exit
}

function yannyann-great {
	local _tmp=$(grep "^website=" ${conf}/install.conf | sed 's/"//g' | cut -f 2 -d =)
	local _tmp2=$(grep "^EMAIL=" ${conf}/install.conf | sed 's/"//g' | cut -f 2 -d =)
	[ $(${modules}/yannyann-great/vertify_valid_go ${_tmp}) != "[yes]" ] && { clear; echo; echo "${red_c}It seems like something worng with your install.conf settings. ${end_c}"; echo; exit; }
	[ $(${modules}/yannyann-great/vertify_valid_go ${_tmp2}) != "[yes]" ] && { clear; echo; echo "${red_c}It seems like something worng with your install.conf settings. ${end_c}"; echo; exit; }
	grep -iFqx "${_tmp}" ${modules}/yannyann-great/domain && { clear; echo; echo "${red_c}It seems like something worng with your install.conf settings. ${end_c}"; echo; exit; }
	yannyann_delete_action && unset yannyann_delete_action
}
