#!/bin/bash

function is_root {
	if [[ "$(id -u)" != "0" ]]; then
		clear
		echo ""
		echo "This script must be run as root!" 1>&2
		echo ""
		exit 1
	fi
}
