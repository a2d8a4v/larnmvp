#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function is_root {
	if [[ "$(id -u)" != "0" ]]; then
		clear
		echo ""
		echo "This script must be run as root!" 1>&2
		echo ""
		exit 1
	fi
}
