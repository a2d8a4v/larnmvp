#!/bin/bash

## --- Please arrange the files by the order of installation 
# here is mvc , v part
function import_check {
	. ${check}/check_email.sh
	. ${check}/check_domain.sh
	. ${check}/check_server.sh
	. ${check}/check_apache2_port.sh
	. ${check}/check_sftp_port.sh
	. ${check}/check_all_settings.sh
	. ${check}/check_sftp_username.sh
	. ${check}/check_wp_dic_name.sh
}
