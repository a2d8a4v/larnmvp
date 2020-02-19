#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

# working even if somebody run "sh larnmvp.sh"
set -e

## -- local settings
readonly _CURRENT_PATH="$PWD"
readonly OPT="/opt"
readonly _INSTALL_DIR="${OPT}/yannyann_larnmvp"
readonly YANN_DIR="${OPT}/yannyann_config"
readonly YANN_PRO="${OPT}/yannyann_produce"
readonly _ME=$(basename "$0")
readonly _REAL_ME="larnmvp.sh"

## -- create the run chroot
mkdir -v -p ${OPT}

## -- if this file is not named larnmvp.sh, rename it
# @https://stackoverflow.com/questions/192319/how-do-i-know-the-script-file-name-in-a-bash-script
if [[ ${_ME} != ${_REAL_ME} ]]; then
	mv ./$0 ./${_REAL_ME}.sh
fi

## -- if not run at /opt/yannyann_larnmvp, move over there
if [[ ${_CURRENT_PATH} != ${_INSTALL_DIR} ]]; then
	if [[ -d "${_INSTALL_DIR}" ]]; then
		rm -rf ${_INSTALL_DIR}
	fi
	# mv here ${_CURRENT_PATH} to ${_INSTALL_DIR}
	mv -f ${_CURRENT_PATH} ${_INSTALL_DIR}
	chown -R root:root ${_INSTALL_DIR} && chmod -R 644 ${_INSTALL_DIR}
	cd ${_INSTALL_DIR}
	## -- define dir path
	readonly dir="${_INSTALL_DIR}"
else
	readonly dir="${_CURRENT_PATH}"
fi

## -- setting for our tools directories
readonly conf="${dir}/conf"
readonly INI="${dir}/ini"
readonly imp="${dir}/imp"
readonly runs="${dir}/runs"
readonly tools="${dir}/tools"
readonly check="${dir}/check"
readonly modules="${dir}/modl"

## -- Some settings released in the future
# Caddy Server or Nginx Server, default is nginx, you can only type: nginx or caddy
CADDY_NGINX="nginx"
# sftp account in OS system, default is empty
ADMNAME=""
# WordPress dicretory, default is wphtml, can only type in numbers and characters
WP_AD="wphtml"
# The port of Apache, default is 8080
apaport="8080"
# The port of SFTP, default is 22
sftpport="22"

## -- import all the tools we need
. ${imp}/import_tools.sh
. ${imp}/import_check.sh
. ${imp}/import_runs.sh
. ${imp}/import_modules.sh
import_tools
import_check
import_runs
import_modules

## -- import basic arguments
do_arguments_setup

## -- check version number
version_check

## -- DNS setting should be the same
dns_on

## -- Disk space should bigger than 9 GB
disk_on

## -- should have internet
internet_on

## -- should run as root
#@@@ there should not any function be executed above
is_root

## -- run install!
do_install > $dnuloger
