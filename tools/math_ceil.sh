#!/bin/bash

# @https://unix.stackexchange.com/questions/168476/convert-a-float-to-the-next-integer-up-as-opposed-to-the-nearest

function math_ceil {
	echo "define ceil (x) {if (x<0) {return -x/1} \
		else {if (scale(x)==0) {return x} \
		else {return x/1 + 1 }}} ; ceil($1)" | bc
}
