#!/bin/bash

function internet_on {
	# @https://stackoverflow.com/questions/929368/how-to-test-an-internet-connection-with-bash
	for interface in $(ls /sys/class/net/ | grep -v lo); do
  		if [[ $(cat /sys/class/net/$interface/carrier) = 1 ]]; then
  			OnLine=1
  		fi
	done
	if ! [ $OnLine ]; then
		clear
		echo ""
		echo "No Internet available, stop." 1>&2
		echo ""
		exit 1
	fi
}
