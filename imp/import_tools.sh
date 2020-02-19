#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

## --- Please arrange the files by the order of installation 
# here is mvc , v part
function import_tools {
	. ${tools}/is_root.sh
	. ${tools}/LOG_T.sh
	. ${tools}/copy_self.sh
	. ${tools}/delete_self.sh
	. ${tools}/interupt_cc.sh
	. ${tools}/email_validator.sh
	. ${tools}/name_validator.sh
	. ${tools}/domain_validator.sh
	. ${tools}/text_contain.sh
	. ${tools}/what_instance_from.sh
	. ${tools}/aptget_update.sh
	. ${tools}/leave_exit.sh	
	. ${tools}/sleep_short_time.sh
	. ${tools}/check_point.sh
	. ${tools}/lower_case.sh
	#. ${tools}/protect_key.sh
	. ${tools}/timestamp.sh
	. ${tools}/getyeardays.sh
	. ${tools}/internet_on.sh
	. ${tools}/version_check.sh
	. ${tools}/random_number_sequence.sh
	. ${tools}/dns_on.sh
	. ${tools}/disk_on.sh
	. ${tools}/printf_nothing.sh
	. ${tools}/math_ceil.sh
}
