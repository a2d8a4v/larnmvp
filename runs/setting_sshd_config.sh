#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_sshd_config {
	## -- make sysconfig port from 22 to whatever you typed
	# @https://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html
	if [[ $( what_instance_from ) == "gcp" ]];then
		sed -i "\$aPort ${sftpport}\nPermitRootLogin no" ${sshd_config_path}
	elif [[ $( what_instance_from ) == "linode" ]]; then
		sed -i "\$aPort ${sftpport}" ${sshd_config_path}
		sed -i 's/.*PermitRootLogin yes/#&/' ${sshd_config_path}
		sed -i -e '\,#PermitRootLogin yes,  i \PermitRootLogin no' ${sshd_config_path}
	fi
	systemctl restart sshd.service
}
