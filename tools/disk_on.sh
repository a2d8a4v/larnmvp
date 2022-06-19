#!/bin/bash

#########################################################################################################################
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website   : https://www.yannyann.com
#########################################################################################################################

## -- Reference
#########################################################################################################################
##
## @@ Greater or equal as number
## # @https://stackoverflow.com/questions/18668556/comparing-numbers-in-bash
## @@ remove the last char from string
## # @https://unix.stackexchange.com/questions/399392/how-do-i-remove-the-last-characters-from-a-string
##
#########################################################################################################################

function disk_on {
	local _tmp1=$(df -k | awk '$6 ~ /^\/$/{print $2}' | echo $(($(xargs)/1048)))
	local _tmp2=$(df -k | awk '$6 ~ /^\/$/{print $4}' | echo $(($(xargs)/1048)))
	local _tmp3=$(df -k | awk '$6 ~ /^\/$/{print $5}' | printf "%.2s" $(xargs) )
	[[ ${_tmp1} -gt 9000 ]] || { clear; echo; echo "${red_c}Your disk space should bigger than 10GB, stop. ${end_c}" 1>&2; echo; exit 1; }
	[[ ${_tmp2} -gt 8000 ]] || { clear; echo; echo "${red_c}Your disk available space should bigger than 9GB, stop. ${end_c}" 1>&2; echo; exit 1; }
	if [[ ${_tmp3} -ge 20 ]]; then
		clear; echo; echo "${red_c}Your disk usage is bigger than 20%, stop. ${end_c}" 1>&2; echo; exit 1;
	fi
}
