#!/bin/bash

# @https://blog.longwin.com.tw/2017/04/bash-shell-date-ymdhis-arg-awk-2017/
function getyeardays {
	for m in {1..12}; do
		a=$(date -d "yesterday $m/1 + 1 month" "+%b - %d days")
	done
}
