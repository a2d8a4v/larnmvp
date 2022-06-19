#!/bin/bash

#########################################################################################################################
## Easter Eag
## version 0.0.1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website   : https://www.yannyann.com
#########################################################################################################################

## -- Referance block
#########################################################################################################################
##
## @@ National Taiwan University ip address rules
## # @http://kissinwang.pixnet.net/blog/post/36496353-%5B網路%5D-ip位址對照表
## # @https://pttpedia.fandom.com/zh/wiki/台灣大學ip
## @@ split strng by delimiter
## # @https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
##
#########################################################################################################################

function yannyann-easter-egg {
	local red_c=$(tput setaf 1)
	local gre_c=$(tput setaf 2)
	local bro_c=$(tput setaf 3)
	local pur_c=$(tput setaf 4)
	local pin_c=$(tput setaf 5)
	local blu_c=$(tput setaf 6)
	local whi_c=$(tput setaf 7)
	local end_c=$(tput sgr0)
	local _tmp_addrip="$(last -20 -i | sed 1q | awk '{print $3}')"
	IFS='.' read -ra _tmp_array <<< "${_tmp_addrip}"; unset IFS
	local _tmp="$(python ${modules}/yannyann-easter-egg/get_ipaddr_isp.py ${_tmp_addrip})"
	local _tmp2="$(python ${modules}/yannyann-easter-egg/get_ipaddr_as.py ${_tmp_addrip})"
	[ -n $( grep -i "National Taiwan University" "${_tmp}" ) -o -n $( grep -i "National Taiwan University" "${_tmp2}" ) -a "${_tmp_array[0]}" -eq "140" -a "${_tmp_array[1]}" -eq "112" ] && { clear; sleep 1s; echo "
${red_c}################################################################################${end_c}
Hello, I'm ${pur_c}YannYann${end_c}, also graduated from ${gre_c}National Taiwan University${end_c},
${blu_c}Now THANK YOU for using my projects, hope you can use my project without
difficulties, even hope you can learn something more from my project.${end_c}
${whi_c}The setup will continue in 5 seconds...${end_c}
${red_c}################################################################################${end_c}"; sleep 5s}
	unset _tmp_array
}
