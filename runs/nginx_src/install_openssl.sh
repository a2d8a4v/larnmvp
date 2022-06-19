#!/bin/bash

function install_openssl {
	## -- openssl
	# @ close for we change to use BoringSSL
	# @https://github.com/hakasenyang/openssl-patch
	mkdir -pv ${dir}/${NGINX_INSTALL}
	wget https://www.openssl.org/source/openssl-3.0.1.tar.gz -O ${dir}/${NGINX_INSTALL}/openssl.tar.gz
	if [[ -d "${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}" ]];then
		rm -rf ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	fi
	tar zxf ${dir}/${NGINX_INSTALL}/openssl.tar.gz --directory=${dir}/${NGINX_INSTALL} && mv -f ${dir}/${NGINX_INSTALL}/openssl-* ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	# Equal patch (Only one of two to select)
	#curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1b.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1b_ciphers.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1c-prioritize_chacha_draft.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1d_ciphers.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1d.patch | patch -p1

	# CHACHA20-POLY1305-OLD Patch
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1b-chacha_draft.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1c-chacha_draft.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1d-chacha_draft.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1h-chacha_draft.patch | patch -p1

	## install openssl 3.0 or up
	# @https://cromwell-intl.com/open-source/nginx-tls-1.3/building-openssl-nginx.html
	# ./config --prefix=/usr/local/openssl-3.0.0 --openssldir=/usr/local/openssl-3.0.0 enable-fips
	# export LD_LIBRARY_PATH=/usr/local/openssl-3.0.0/lib
	./config --prefix=/usr/local/openssl-3.0.0 --openssldir=/usr/local/openssl-3.0.0 enable-fips
	export LD_LIBRARY_PATH=/usr/local/openssl-3.0.0/lib
	make -j$(nproc --all) && make install

	cd ${dir}/${NGINX_INSTALL}
}
