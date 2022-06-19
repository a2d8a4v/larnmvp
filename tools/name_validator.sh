#!/bin/bash

function name_validator {
	# @https://gist.github.com/guessi/82a73ee7eb2b1216eb9db17bb8d65dd1
  	echo "$1" | egrep --quiet "^[a-z][-a-z0-9_]*\$"
  	[ $? -eq 0 ] && printf "[yes]" || printf "[no]"
}
