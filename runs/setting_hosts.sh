#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_hosts {
	# for security issue, we should put on some block list
	cat ${INI}/hosts_ini/hosts.txt >> /etc/hosts
}
