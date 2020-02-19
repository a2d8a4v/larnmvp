#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_varnish {
	apt-get install varnish -y
	#apt-get install varnish-dev -y
	# let varnish make up a secret file, so 
	service varnish start
	dd if=/dev/random of=/etc/varnish/secret count=1
	# @https://www.varnish-software.com/wiki/content/tutorials/varnish/run_varnish.html
	# @https://varnish-cache.org/docs/trunk/users-guide/run_security.html

	# tweak varnish system resource
	# @https://www.slideshare.net/perbu/tuning-the-kernel-for-varnish-cache [this one is important]
	# @https://serverfault.com/questions/542106/how-to-improve-varnish-performance
	# @https://www.itread01.com/content/1501938140.html
	# @https://varnish-cache.org/forum/topic/918
	mkdir -p -v /etc/varnish/conf.d/
	mv -f ${INI}/varnish_ini/varnish_default /etc/default/varnish
	chown root:root /etc/default/varnish && chmod 644 /etc/default/varnish
	mv -f ${INI}/varnish_ini/{bad_ip.vcl,bad_bot.vcl,devicedetect.vcl} /etc/varnish/conf.d/
	# notice: /etc/systemd/system/multi-user.target.wants/varnish.service is symlink file
	# reload-vcl is already disrupted in Ubuntu
	# @https://www.claudiokuenzler.com/blog/720/varnish-vcl-reload-not-working-systemd-ubuntu-16.04
	mv -f ${INI}/varnish_ini/varnish.service /lib/systemd/system && chmod -R 644 /lib/systemd/system/varnish.service && chown -R root:root /lib/systemd/system/varnish.service
	mv -f ${INI}/varnish_ini/${varnishdefault} /etc/varnish/ && chmod -R 644 /etc/varnish/${varnishdefault} && chown -R root:root /etc/varnish/${varnishdefault}
	rm -R /etc/varnish/default.vcl

	systemctl daemon-reload
	service apache2 stop
	service apache2 start
	service varnish restart
	systemctl enable varnish

	# if we want to install varnish 6.1,  now varnish-cache doesnt update the packages for Ubuntu 18.10. so we should git clone and compile to install by ourself..
	#https://websiteforstudents.com/varhish-cache-6-1-released-heres-how-to-install-upgrade-on-ubuntu-16-04-18-04-18-10/
	#but the defaults does not like the diterory above.
}
