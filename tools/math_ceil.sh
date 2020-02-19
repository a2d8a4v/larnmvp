#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

# @https://unix.stackexchange.com/questions/168476/convert-a-float-to-the-next-integer-up-as-opposed-to-the-nearest
function math_ceil {
	echo "define ceil (x) {if (x<0) {return -x/1} \
		else {if (scale(x)==0) {return x} \
		else {return x/1 + 1 }}} ; ceil($1)" | bc
}
