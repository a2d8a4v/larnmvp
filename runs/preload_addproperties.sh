#!/bin/bash

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
	#old version
	# apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
	# add-apt-repository 'deb [arch=amd64] http://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.3/ubuntu bionic main'
	# @https://mariadb.com/kb/en/library/mariadb-package-repository-setup-and-usage/
	# curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
	# @https://kifarunix.com/install-mariadb-10-4-on-ubuntu-18-04-debian-9/
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
	add-apt-repository -y 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu bionic main'


	## --- varnish
	#old version
	#curl -s https://packagecloud.io/install/repositories/varnishcache/varnish60/script.deb.sh | bash
	# curl -s https://packagecloud.io/install/repositories/varnishcache/varnish60lts/script.deb.sh | sudo bash
	# curl -s https://packagecloud.io/install/repositories/varnishcache/varnish62/script.deb.sh | sudo bash
	# curl -s https://packagecloud.io/install/repositories/varnishcache/varnish63/script.deb.sh | sudo bash
	# curl -s https://packagecloud.io/install/repositories/varnishcache/varnish64/script.deb.sh | sudo bash
	# curl -L https://packagecloud.io/varnishcache/varnish64/gpgkey | sudo apt-key add -
	# touch /etc/apt/sources.list.d/varnishcache_varnish64.list
	# echo "deb https://packagecloud.io/varnishcache/varnish64/ubuntu/ bionic main" >> /etc/apt/sources.list.d/varnishcache_varnish64.list
	# echo "deb-src https://packagecloud.io/varnishcache/varnish64/ubuntu/ bionic main" >> /etc/apt/sources.list.d/varnishcache_varnish64.list
	curl -L https://packagecloud.io/varnishcache/varnish65/gpgkey | sudo apt-key add -
	touch /etc/apt/sources.list.d/varnishcache_varnish65.list
	echo "deb https://packagecloud.io/varnishcache/varnish65/ubuntu/ focal main" >> /etc/apt/sources.list.d/varnishcache_varnish65.list
	echo "deb-src https://packagecloud.io/varnishcache/varnish65/ubuntu/ focal main" >> /etc/apt/sources.list.d/varnishcache_varnish65.list
	wget https://repo.percona.com/apt/pool/main/j/jemalloc/libjemalloc1_3.6.0-2.focal_amd64.deb -O ${dir}/libjemalloc.deb
	dpkg -i ${dir}/libjemalloc.deb && rm -f ${dir}/libjemalloc.deb


	## --- install python
	touch /etc/apt/sources.list.d/python3.list
	echo "deb http://us.archive.ubuntu.com/ubuntu/ focal main restricted universe" >> /etc/apt/sources.list.d/python3.list


	## --- install some tools used for compile
	# @https://kx.cloudingenium.com/linux/ubuntu/build-version-nginx/
	apt-get -qq install apt-transport-https software-properties-common wget gnupg build-essential libpcre3 libpcre3-dev zlib1g-dev git tcl zip unzip pkg-config gcc make autoconf libc-dev php${PHP_VER}-dev php${PHP_VER}-cli php-pear libpcap-dev libnet-dev automake libnet1-dev libtool libxslt-dev libgd-dev libgeoip-dev libaio1 libaio-dev cargo libmagickwand-dev libperl-dev
	# install rust
	# @https://github.com/rust-lang/rustup/issues/297
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

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
		# apt-get -qq install openjdk-8-jdk
		# echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
		# curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
		# aptget_update
		# apt-get -qq install bazel pkg-config zip g++ zlib1g-dev unzip python-dev cmake build-essential autoconf automake libjemalloc-dev libssl-dev git software-properties-common openjdk-8-jdk
	else
		## default use google
		aptget_update
		apt-get -qq install pkg-config zip g++ zlib1g-dev unzip python
		wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh -O ${dir}/bazel.sh
		chmod a+x ${dir}/bazel.sh && ${dir}/bazel.sh
		# apt-get -qq install openjdk-8-jdk
		# echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
		# curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
		# aptget_update
		# apt-get -qq install bazel pkg-config zip g++ zlib1g-dev unzip python-dev cmake build-essential autoconf automake libjemalloc-dev libssl-dev git software-properties-common openjdk-8-jdk
	fi
}
