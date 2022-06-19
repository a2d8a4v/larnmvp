#!/bin/bash

#########################################################################################################################
## logger
## version 0.0.1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website   : https://www.yannyann.com
#########################################################################################################################

## -- Referance block
#########################################################################################################################
## 
## @@ setting and use for monitor the while installation proccessing
## # @https://stackoverflow.com/questions/25635071/bash-redirect-to-screen-or-dev-null-depending-on-flag
##
#########################################################################################################################

function yannyann-logger {
	## -- controling for showing on screen or hide message
	## logging and show on screnn at the same time
	readonly dnuloger="| tee -a ${dir}/.larnmvp_process.txt"
	## no log and no show
	# readonly dnuloger="> /dev/null 2>&1"
	## only show
	# readonly dnuloger="/dev/tty"
	## only logging
	# readonly dnuloger="${dir}/.larnmvp_process.txt"
}
