#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function text_contain {
	while true; do
		if [[ -f $1 ]];then
			if grep -q $2 $1 ;then
				# true && break
				printf "[yes]" && break
			else
				printf "[no]" && break
				# false && break
			fi
		fi
	done
}
