#!/bin/bash

## -- copy logs
function copy_self {
	# save to "ubuntu" account diterory. /home/ubuntu
	cd ${dir}
	mkdir -p -v ${YANN_DIR}/.yannyann_larnmvp
	if [[ -e ${scfg} ]]; then
		cp -p ${scfg} ${YANN_DIR}/.yannyann_larnmvp/.larnmvp_logs
	fi
	if [[ -e ${dir}/test_time.log ]]; then
		cp -p ${dir}/test_time.log ${YANN_DIR}/.yannyann_larnmvp/.larnmvp_time_logs
	fi
	if [[ -e "/var/log/syslog" ]];then
		cp -p /var/log/syslog ${YANN_DIR}/.yannyann_larnmvp/.larnmvp_syslog
	fi
}
