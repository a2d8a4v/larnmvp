#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function lower_case {
	# @https://stackoverflow.com/questions/2264428/how-to-convert-a-string-to-lower-case-in-bash
	printf "$1" | tr '[:upper:]' '[:lower:]'
}
