#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function preload_trap {
	trap "interupt_cc" SIGINT INT TERM SIGTERM EXIT
	check_point
}
