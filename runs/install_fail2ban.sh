#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_fail2ban {
	apt-get install fail2ban -y
	service fail2ban start
	systemctl enable fail2ban
}
