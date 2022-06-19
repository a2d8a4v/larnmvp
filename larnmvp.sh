#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-2
## Developer : Yannyann (https://github.com/a2d8a4v)
## This file is also referenced from cerbot-auto and easyengine 4 install shell script as example
## Thanks for @wartw98 at Github help me fix the openssh-serve attended installation problem.
## For the installition will take some time, i think it is better to run some tools like "screen" make the script run 
## even if the terminal disconnect with the vps
## 
## Let's start install!! Enjoy it!
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
mkdir -pv ${OPT}

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

## -- import all the tools we need
. ${imp}/import_tools.sh
. ${imp}/import_check.sh
. ${imp}/import_runs.sh
#. ${imp}/import_modules.sh
import_tools
import_check
import_runs
#import_modules

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
