#!/bin/bash

# @https://blog.longwin.com.tw/2017/04/bash-shell-date-ymdhis-arg-awk-2017/
function random_number_sequence {
	printf "$(shuf -i ${1}-${2} -n 1)"
}
