#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

## -- Log how much time should be used in every step.
function LOG_T {
	if ! [[ -e "${dir}/test_time.log" ]];then
		echo "" >> ${dir}/test_time.log
	fi
	while true; do
		DATE=`date '+%Y-%m-%d %H:%M:%S'`
		break
	done
	echo -e "${DATE}\n" >> ${dir}/test_time.log
}
