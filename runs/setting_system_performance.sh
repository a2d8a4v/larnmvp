#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_system_performance {
	sysctl -p > $dnuloger 2>&1 || echo

	## -- setting for nginx
	sed -i '/worker_processes/aworker_rlimit_nofile 102400;' /etc/nginx/nginx.conf
	service nginx reload
}
