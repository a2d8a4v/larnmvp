#!/bin/bash

function preload_hostname {
	echo ${domain} > /etc/hostname
	hostname -F /etc/hostname
}
