#!/bin/bash

function what_instance_from {
	if grep -rn "gcp" /run/motd.dynamic >/dev/null 2>&1;then
		printf "gcp"
	elif grep -rn "linode" /etc/apt/sources.list >/dev/null 2>&1;then
		printf "linode"
	elif grep -rn "digitalocean" /etc/apt/sources.list >/dev/null 2>&1;then
		printf "digitalocean"
	fi
}
