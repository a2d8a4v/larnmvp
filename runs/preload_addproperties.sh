#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

#make up the install settings
function preload_addproperties {
	## --- some common packages
	# detect installed or not
	if command -v curl > $dnuloger; then
		echo "curl was installed."
	else
		apt-get -qq install curl
	fi
	
	## --- php
	add-apt-repository -y ppa:ondrej/php

	## -- apache
	add-apt-repository -y ppa:ondrej/apache2

	## --- mariadb
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
	add-apt-repository -y 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu bionic main'



	## --- varnish
	curl -s https://packagecloud.io/install/repositories/varnishcache/varnish63/script.deb.sh | sudo bash

	## --- install some tools used for compile
	# @https://kx.cloudingenium.com/linux/ubuntu/build-version-nginx/
	apt-get -qq install apt-transport-https software-properties-common wget gnupg build-essential libpcre3 libpcre3-dev zlib1g-dev git tcl zip unzip pkg-config gcc make autoconf libc-dev php${PHP_VER}-dev php${PHP_VER}-cli php-pear libpcap-dev libnet-dev automake libnet1-dev libtool libxslt-dev libgd-dev libgeoip-dev

	## -- install libraries for compiling boringssl or openssl
	if [[ ${NGINX_FROM} == "nginx" ]];then
		# instal for maxmind
		add-apt-repository -y ppa:maxmind/ppa
		apt-get -qq install libmaxminddb-dev

		# install for OpenResty
		# apt-get -qq install libreadline-dev libpcre3-dev libssl-dev perl

		if [[ ${SSL_CONF} == "b" ]];then
			apt-get -qq install golang cmake clang build-essential
		elif [[ ${SSL_CONF} == "o" ]];then
			echo "nothing to do."
		else
			# default use boringssl
			apt-get -qq install golang cmake clang build-essential
		fi
	elif [[ ${NGINX_FROM} == "google" ]];then
		# @https://github.com/bazelbuild/bazel/releases
		# @https://docs.bazel.build/versions/master/install-ubuntu.html
		aptget_update
		apt-get -qq install pkg-config zip g++ zlib1g-dev unzip python
		wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh -O ${dir}/bazel.sh
		chmod a+x ${dir}/bazel.sh && ${dir}/bazel.sh
	else
		## default use google
		aptget_update
		apt-get -qq install pkg-config zip g++ zlib1g-dev unzip python
		wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh -O ${dir}/bazel.sh
		chmod a+x ${dir}/bazel.sh && ${dir}/bazel.sh
	fi
}
