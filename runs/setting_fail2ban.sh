 #!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

#https://ubuntu101.co.za/security/fail2ban/fail2ban-persistent-bans-ubuntu/
function setting_fail2ban {
	mv -f ${INI}/fail2ban_ini/blacklist.conf /etc/fail2ban/filter.d
	mv -f ${INI}/fail2ban_ini/blacklist2.conf /etc/fail2ban/action.d/blacklist.conf
	cat ${INI}/fail2ban_ini/conf.conf >> /etc/fail2ban/jail.conf
	mv -f ${INI}/fail2ban_ini/ip.blacklist /etc/fail2ban/ && chmod 755 /etc/fail2ban/ip.blacklist

	systemctl daemon-reload
	service fail2ban restart
}
