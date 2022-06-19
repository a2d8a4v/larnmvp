#!/bin/bash

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

#==============

#Package configuration


 #┌─────────────────────────────────────────────────────┤ Configuring openssh-server ├─────────────────────────────────────────────────────┐
 #│ A new version (/tmp/fileNJIy1j) of configuration file /etc/ssh/sshd_config is available, but the version installed currently has been  │ 
 #│ locally modified.                                                                                                                      │ 
 #│                                                                                                                                        │ 
 #│ What do you want to do about modified configuration file sshd_config?                                                                  │ 
 #│                                                                                                                                        │ 
 #│                                          install the package maintainer's version                                                      │ 
 #│                                          keep the local version currently installed                                                    │ 
 #│                                          show the differences between the versions                                                     │ 
 #│                                          show a side-by-side difference between the versions                                           │ 
 #│                                          show a 3-way difference between available versions                                            │ 
 #│                                          do a 3-way merge between available versions                                                   │ 
 #│                                          start a new shell to examine the situation                                                    │ 
 #│                                                                                                                                        │ 
 #│                                                                                                                                        │ 
 #│                                                                 <Ok>       

 #==============