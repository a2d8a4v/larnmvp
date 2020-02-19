#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_openssl {
	## -- openssl
	# @ close for we change to use BoringSSL
	# @https://github.com/hakasenyang/openssl-patch
	mkdir -p -v ${dir}/${NGINX_INSTALL}
	wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz -O ${dir}/${NGINX_INSTALL}/openssl.tar.gz
	if [[ -d "${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}" ]];then
		rm -rf ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	fi
	tar zxf ${dir}/${NGINX_INSTALL}/openssl.tar.gz --directory=${dir}/${NGINX_INSTALL} && mv -f ${dir}/${NGINX_INSTALL}/openssl-* ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	# Equal patch (Only one of two to select)
	#curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1b.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1b_ciphers.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1c-prioritize_chacha_draft.patch | patch -p1
	curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1d_ciphers.patch | patch -p1
	curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1d.patch | patch -p1

	# CHACHA20-POLY1305-OLD Patch
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1b-chacha_draft.patch | patch -p1
	# curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1c-chacha_draft.patch | patch -p1
	curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-1.1.1d-chacha_draft.patch | patch -p1


	cd ${dir}/${NGINX_INSTALL}
}
