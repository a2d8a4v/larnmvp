#!/bin/bash

function text_contain {
	while true; do
		if [[ -f $1 ]];then
			if grep -q $2 $1 ;then
				# true && break
				printf "[yes]" && break
			else
				printf "[no]" && break
				# false && break
			fi
		fi
	done
}
