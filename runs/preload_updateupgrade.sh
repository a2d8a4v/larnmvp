#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

#run update and upgarde
function preload_updateupgrade {
	##@@@@it update could have some interactive action , like openssh-server for i change the configuration of ssh config
	export DEBIAN_FRONTEND="noninteractive"
	if (( ${SSHD_GO} == 0 )); then
		echo "ssopenssh-server openssh-server/configuration_openssh-server select the local version currently installed" | debconf-set-selections
	elif (( ${SSHD_GO} == 1 )); then
		echo "ssopenssh-server openssh-server/configuration_openssh-server select the package maintainer's version" | debconf-set-selections
	fi
	apt-get -qq install --only-upgrade openssh-server

	## -- keyboard-configuration
	export DEBIAN_FRONTEND="noninteractive"
	echo "sskeyboard-configuration keyboard-configuration/configuring_keyboard-configuration select English (US)" | debconf-set-selections
	echo "sskeyboard-configuration keyboard-configuration/configuring_keyboard-configuration select English (US)" | debconf-set-selections
	apt-get -qq install --only-upgrade keyboard-configuration

	aptget_update
	# if it is not the first run, do not run remove again
	if [[ -z "${APT_REMOVE}" ]]; then
		apt-get -qq autoremove
		APT_REMOVE="YES"
	fi
}
