#!/bin/bash

# @https://blog.longwin.com.tw/2017/04/bash-shell-date-ymdhis-arg-awk-2017/
function timestamp {
	printf "$(date +"%Y-%m-%d-%H-%M-%S")"
}
