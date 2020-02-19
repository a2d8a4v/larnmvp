#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

## -- Reference
#########################################################################################################################
##
## @@ get DNS information
## # @https://www.cyberciti.biz/faq/unix-linux-dns-lookup-command/
## # @https://www.a2hosting.com/kb/getting-started-guide/internet-and-networking/troubleshooting-dns-with-dig-and-nslookup
## @@ get last substring
## # @https://stackoverflow.com/questions/22727107/how-to-find-the-last-field-using-cut
## @@ extract string from quotation
## # @https://unix.stackexchange.com/questions/137030/how-do-i-extract-the-content-of-quoted-strings-from-the-output-of-a-command
##
#########################################################################################################################

function dns_on {
	local _tmp=(http://ipv4.icanhazip.com http://api.ipify.org http://ipecho.net/plain http://icanhazip.com http://ifconfig.me/ip)
	local _tmp2="$(grep "^website=" ${conf}/install.conf | sed 's/"//g' | cut -f 2 -d =)"
	local _tmp3="$(dig +nocmd +noall +answer a "$(grep "^website=" ${conf}/install.conf | sed 's/"//g' | cut -f 2 -d =)" | rev | cut -f 1 -d$'\t' | rev)"
	IFS=\. read -a _tmp4 <<< "${_tmp2}"
	if [[ "${_tmp4[0]}" != "www" ]] && (( ${#_tmp4[@]} == 3 )); then
		local domain="${_tmp4[0]}.${_tmp4[1]}.${_tmp4[2]}"
	elif [[ "${_tmp4[0]}" != "www" ]] && (( ${#_tmp4[@]} == 2 )); then
		local domain="${_tmp4[0]}.${_tmp4[1]}"
	else
		if [[ "${_tmp4[0]}" == "www" ]] && (( ${#_tmp4[@]} == 3 )); then
			local domain="${_tmp4[1]}.${_tmp4[2]}"
		elif [[ "${_tmp4[0]}" == "www" ]] && (( ${#_tmp4[@]} == 4 )); then
			local domain="${_tmp4[1]}.${_tmp4[2]}.${_tmp4[3]}"
		fi
	fi
	apt-get -qq install curl > /dev/null 2>&1
	if [[ ! -n "$(dig +nocmd +noall +answer a $(grep "^website=" ${conf}/install.conf | sed 's/"//g' | cut -f 2 -d = ))" ]] && [[ "$( dig +nocmd +noall +answer a ${domain} | rev | cut -f 1 -d$'\t' | rev )" != "$( curl -kLs ${_tmp["$(random_number_sequence 0 4)"]})" ]];then
		clear
		echo
		echo "${red_c}Your DNS setting has some mistakes, please go back to check again, stop. ${end_c}"
		echo
		exit
	fi
	if [[ ! -n "$(dig @1.1.1.1 +nocmd +noall +answer a "www.${domain}")" ]];then
		clear
		echo
		echo "${red_c}You should add a record in DNS setting for www like: 'www.${domain}. 300 IN A $(curl -kLs ${_tmp["$(random_number_sequence 0 5)"]})' or 'www.${domain}. 300 IN CNAME ${domain}.' , stop. ${end_c}"
		echo
		exit
	fi
	unset _tmp
	unset _tmp2
	unset _tmp3
	unset _tmp4
	unset domain
}
