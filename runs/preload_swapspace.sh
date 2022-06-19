#!/bin/bash

function preload_swapspace {
	if [[ ${SWAP_N_SIZE} -gt 0 ]];then
		fallocate -l ${SWAP_N_SIZE}M ${SWAP_FILE}
		# dd if=/dev/zero of=${SWAP_FILE} count=${SWAP_N_SIZE} bs=1M
		chmod 600 ${SWAP_FILE}
		mkswap ${SWAP_FILE}
		swapon ${SWAP_FILE}
		[ -z "$(grep ${SWAP_FILE} /etc/fstab)" ] && echo "${SWAP_FILE} none swap sw 0 0" | tee -a /etc/fstab
		sysctl vm.swappiness=10
		sysctl vm.vfs_cache_pressure=50
		echo "vm.swappiness=10" | tee -a /etc/sysctl.conf
		echo "vm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf
	fi
}
