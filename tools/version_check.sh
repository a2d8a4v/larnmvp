#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

# @https://blog.longwin.com.tw/2017/04/bash-shell-date-ymdhis-arg-awk-2017/
function version_check {
	if [[ ! -e ${dir}/VERSION ]]; then
		clear
		echo ""
		echo "Version number unknown! stop." 1>&2
		echo ""
		exit 1
	fi
}
