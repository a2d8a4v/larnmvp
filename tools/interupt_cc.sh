#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

## -- if interrupt
# if exit or interrupt, copy logs and delete all things
function interupt_cc {
	copy_self || echo "pass"
	delete_self || echo "pass"
	exit 2
}
