#!/bin/bash

function setting_cron {
	if [[ ${IS_CUSTOM} == "no" ]];then
		printf_nothing
	else
		## check for crontab
		# crontab -l > "${dir}/mycron" && printf_nothing

		## -- let's encrypt
		mkdir -p -v ${OPT}/letsencrypt/
		mv -f ${INI}/let_ini/let_renew.sh ${OPT}/letsencrypt/ && chmod a+x ${OPT}/letsencrypt/let_renew.sh
		echo "30 3 * * * ${OPT}/letsencrypt/let_renew.sh" >> ${dir}/mycron

		## -- setting for fail2ban
		## make a little application for update ip blacklist automatically
		mkdir -p -v ${OPT}/fail2ban
		mv -f ${INI}/fail2ban_ini/fail2ban_blacklist.sh ${OPT}/fail2ban/ && chmod a+x ${OPT}/fail2ban/fail2ban_blacklist.sh
		echo "30 * * * * ${OPT}/fail2ban/fail2ban_setting.sh" >> ${dir}/mycron

		## -- setting for varnish
		# clean all the varnish cache at everyday a.m. 4:00
		mkdir -p -v ${OPT}/varnish/
		mv -f ${INI}/custom_ini/clean_varnish_cache.sh ${OPT}/varnish/ && chmod a+x ${OPT}/varnish/clean_varnish_cache.sh
		echo "00 4 * * * ${OPT}/varnish/clean_varnish_cache.sh" >> ${dir}/mycron

		## -- import into crontab
        cat ${dir}/mycron > /var/spool/cron/crontabs/root
        chmod 600 /var/spool/cron/crontabs/root
        chown root:crontab /var/spool/cron/crontabs/root
		# crontab ${dir}/mycron
		rm ${dir}/mycron
	fi
}
