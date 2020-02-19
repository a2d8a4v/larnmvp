#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function name_validator {
	# @https://gist.github.com/guessi/82a73ee7eb2b1216eb9db17bb8d65dd1
  	echo "$1" | egrep --quiet "^[a-z][-a-z0-9_]*\$"
  	[ $? -eq 0 ] && printf "[yes]" || printf "[no]"
}
