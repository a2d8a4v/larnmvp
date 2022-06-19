#!/bin/bash

function install_fail2ban {
	apt-get install fail2ban -y
	service fail2ban start
	systemctl enable fail2ban
}
