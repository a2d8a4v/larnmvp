#!/bin/bash

function setting_sftp_jail {
	if [[ -z ${ADMNAME} ]];then
		echo "nothing to do."
	else
		# @https://www.linode.com/docs/tools-reference/tools/limiting-access-with-sftp-jails-on-debian-and-ubuntu/
		# @http://manpages.ubuntu.com/manpages/cosmic/man8/groupadd.8.html
		# @https://passingcuriosity.com/2014/openssh-restrict-to-sftp-chroot/
		# @https://www.tecmint.com/restrict-sftp-user-home-directories-using-chroot/
		# @https://unix.stackexchange.com/questions/206248/restrict-user-to-do-sftp-on-the-www-folder-owned-by-www-data-group
		# @http://mycodetub.logdown.com/posts/774969-set-up-sftp-notes

		## -- Adding a sftp account
		# you should add a system group
		USERLIST=$( cut -d: -f1 /etc/passwd )
		TEST_GROUP=$( cut -d: -f1 /etc/group )
		if [[ ${IS_CUSTOM} == "no" ]];then
			echo "nothing to do."
			echo "do not build jail."
		elif [[ ${IS_CUSTOM} == "yes" ]];then
			mkdir -p -v ${USER_PUB_DIR}
			if [[ " $SFTP_G " =~ .*\ ${TEST_GROUP}\ .* ]]; then
				echo "nothing to do."
			else
				addgroup --system --force-badname --quiet ${SFTP_G} || echo "a"
			fi
			if [[ " ${ADMNAME} " =~ .*\ ${USERLIST}\ .* ]]; then
				echo "User ${TEST_USER_EXSIT} is on the system contact root.yannyann"
			else
				echo "Adding ${TEST_USER_EXSIT} to system"
				adduser --force-badname --disabled-password --gecos --quiet ${ADMNAME} || echo "a"
				gpasswd -d ${ADMNAME} sudo || echo "a"
				echo "nothing to do."
			fi
			if [[ " ${ADMNAME} " =~ .*\ ${TEST_GROUP}\ .* ]]; then
				echo "nothing to do."
			else
				addgroup --force-badname --quiet ${ADMNAME} || echo "a"
			fi
			usermod -d ${USER_PUB_DIR} ${ADMNAME} || echo "a"
			echo ${ADMNAME}:${ADMNAME_PASWD} | chpasswd || echo "a"
			echo "${ADMNAME} ALL=/usr/bin, !/usr/bin/passwd, !/usr/bin/sudo" >> /etc/sudoers.d/${ADMNAME}
			usermod -a -G ${SFTP_G} ${ADMNAME} || echo "a"
			usermod -a -G ${SFTP_G} www-data || echo "a"
		else
			echo "nothing to do."
		fi

		if [[ ${IS_CUSTOM} == "no" ]];then
			usermod -a -G www-data ${ADMNAME} && usermod -a -G sudo ${ADMNAME} || echo "a"
		elif [[ ${IS_CUSTOM} == "yes" ]];then
			usermod -a -G www-data ${ADMNAME} && usermod -a -G ${ADMNAME} www-data || echo "a"
		else
			usermod -a -G www-data ${ADMNAME} && usermod -a -G sudo ${ADMNAME} || echo "a"
		fi

		# if you are using gce, the authorize key would be produce at first, then you should also copy the public key to the new root directory of your account in OS system
		if [[ ${IS_CUSTOM} == "no" ]]; then
			echo "nothing to do."
		elif [[ ${IS_CUSTOM} == "yes" ]]; then
			if [[ $( what_instance_from ) == "gcp" ]]; then
				if [[ -d "/home/${ADMNAME}" ]] && [[ -d "/home/${ADMNAME}/.ssh" ]]; then
					if cp -rf /home/${ADMNAME}/.ssh ${USER_PUB_DIR}; then
						echo "nothing to do."
					fi
					if [[ -e "${USER_PUB_DIR}/.ssh/authorized_keys" ]]; then
						chown ${ADMNAME}:${ADMNAME} ${USER_PUB_DIR} -R && chmod 700 ${USER_PUB_DIR}
						chown ${ADMNAME}:${ADMNAME} ${USER_PUB_DIR}/.ssh -R && chmod 700 ${USER_PUB_DIR}/.ssh/
						chown ${ADMNAME}:${ADMNAME} ${USER_PUB_DIR}/.ssh/authorized_keys && chmod 600 ${USER_PUB_DIR}/.ssh/authorized_keys
					fi
				fi
			else
				if [[ -d "${USER_PUB_DIR}" ]]; then
					chown ${ADMNAME}:${ADMNAME} ${USER_PUB_DIR} -R && chmod 700 ${USER_PUB_DIR}
					if [[ -d "${USER_PUB_DIR}/.ssh" ]] && [[ -e "${USER_PUB_DIR}/.ssh/authorized_keys" ]]; then
						chown ${ADMNAME}:${ADMNAME} ${USER_PUB_DIR}/.ssh -R && chmod 700 ${USER_PUB_DIR}/.ssh/
						chown ${ADMNAME}:${ADMNAME} ${USER_PUB_DIR}/.ssh/authorized_keys && chmod 600 ${USER_PUB_DIR}/.ssh/authorized_keys
					fi
				fi
			fi
		else
			echo "nothing to do."
		fi

		# setting auth
		if [[ ${IS_CUSTOM} == "no" ]];then
			if [[ ${WP_ADMIN_DIR} == ${SITE_DIR} ]];then
				chown www-data:www-data ${SITE_DIR}
			else
				chown www-data:www-data ${WP_ADMIN_DIR}
			fi
		elif [[ ${IS_CUSTOM} == "yes" ]];then
			chown root:root /var ${BASE_DIR} ${SITE_DIR} && chmod 755 /var ${BASE_DIR} ${SITE_DIR}
			if [[ ${WP_ADMIN_DIR} == ${SITE_DIR} ]];then
				echo "nothing to do."
			else
				# it is a commercial logic, for customer is intend to think clever on theirselvs, but if there were some problems happened after we gave the website, they might pay some money
				# setting for WordPress files
				# @https://askubuntu.com/questions/280894/changing-write-permissions-for-jailed-sftp-denies-login
				# @https://serverfault.com/questions/796500/sftp-with-chrootdirectory-option-and-still-allow-user-to-create-modify-directori

				if [[ ! -z ${LEN_WP_AD} ]] && [[ ! -z ${WP_AD} ]] && [[ ${HTA_ROT_IND_SAME_WP_RDIC} == "yes" ]];then
					#@@@ This part should take more care, for 775 and 755 will lead to different goal.
					chown -R www-data:www-data ${WP_ADMIN_DIR} && chmod -R 775 ${WP_ADMIN_DIR}
					chown www-data:${ADMNAME} ${WP_ADMIN_DIR} && chmod 775 ${WP_ADMIN_DIR} && chmod g+s ${WP_ADMIN_DIR}
				else
					chown -R ${ADMNAME}:www-data ${WP_ADMIN_DIR}/wp-admin && chmod -R 755 ${WP_ADMIN_DIR}/wp-admin && chmod g+s ${WP_ADMIN_DIR}/wp-admin
					chown -R ${ADMNAME}:www-data ${WP_ADMIN_DIR}/wp-content && chmod -R 755 ${WP_ADMIN_DIR}/wp-content && chmod g+s ${WP_ADMIN_DIR}/wp-content
					chown -R ${ADMNAME}:www-data ${WP_ADMIN_DIR}/wp-includes && chmod -R 755 ${WP_ADMIN_DIR}/wp-includes && chmod g+s ${WP_ADMIN_DIR}/wp-includes
				fi
			fi
		else
			if [[ ${WP_ADMIN_DIR} == ${SITE_DIR} ]];then
				chown www-data:www-data ${SITE_DIR}
			else
				chown www-data:www-data ${WP_ADMIN_DIR}
			fi
		fi

		# @https://websiteforstudents.com/setup-retrictive-sftp-with-chroot-on-ubuntu-16-04-17-10-and-18-04/
		if [[ ${IS_CUSTOM} == "no" ]];then
			echo "nothing to do."
		elif [[ ${IS_CUSTOM} == "yes" ]];then
			sed -i 's/.*\/sftp-server/#&/' ${sshd_config_path}
			sed -i -e '\,\/sftp-server,  i \Subsystem sftp internal-sftp' ${sshd_config_path}
			echo "
Match Group ${SFTP_G}
  # Force the connection to use SFTP and chroot to the required directory.
  ChrootDirectory ${SITE_DIR}
  ForceCommand internal-sftp -u 0002
	" >> ${sshd_config_path}
			systemctl restart sshd.service

			# last but not the least, delete no using old user root home
			if [[ -d "/home/${ADMNAME}" ]];then
				rm -rf /home/${ADMNAME}
			fi
		else
			echo "nothing to do."
		fi
	fi
}
