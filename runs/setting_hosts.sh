#!/bin/bash

function setting_hosts {
	# for security issue, we should put on some block list
	cat ${INI}/hosts_ini/hosts.txt >> /etc/hosts
}
