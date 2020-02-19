#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

# please read "RCF" documents fo email name rules
function email_validator {
	# @https://gist.github.com/guessi/82a73ee7eb2b1216eb9db17bb8d65dd1
  	[[ "$1" =~ ^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,4})$ ]] && printf "[yes]" || printf "[no]"
}
