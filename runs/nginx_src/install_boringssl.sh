#!/bin/bash

function install_boringssl {
	## -- BoringSSL
	# @https://www.dcc.cat/nginx-google/
	# @https://hk.saowen.com/a/65969ca1fb375232b6a61f2ac9518d7cf1a736d45c9fad58b42f662ee97e0499
	# cd ${dir}/${NGINX_INSTALL}
	#git clone https://github.com/S8Cloud/sslpatch.git ${dir}/${NGINX_INSTALL}/sslpatch
	# git clone -b master https://github.com/google/boringssl.git ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR} && cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	#patch -p1 <../sslpatch/BoringSSL-enable-TLS1.3.patch
	#patch -p1 <../sslpatch/BoringSSL-enable-AES_CBC.patch
	# mkdir -p -v ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build && cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build
	# cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DOPENSSL_SMALL=1 .. && make -j $(nproc)
	# cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/ && mkdir -p -v ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/lib && cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl && ln -s ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/include ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl
	# cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/ && cp ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build/crypto/libcrypto.* ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build/ssl/libssl.* ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/lib
	# cd ${dir}/${NGINX_INSTALL}

	# this is another verison of method
	mkdir -pv ${dir}/${NGINX_INSTALL}
	cd ${dir}/${NGINX_INSTALL}
	if [[ -d "${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}" ]];then
		rm -rf ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	fi
	git clone -b master https://github.com/google/boringssl.git ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR} && cd ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	mkdir -pv ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build
	mkdir -pv ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/lib
	mkdir -pv ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/include
	mkdir -pv ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/include/openssl/
	# ln -sf ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/include ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl
	touch ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/include/openssl/ssl.h
	cmake -B${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build -H${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}
	make -C ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build -j$(nproc --all)
	cp ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build/crypto/libcrypto.* ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build/ssl/libssl.* ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/lib
	# cp ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build/crypto/libcrypto.a  ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/build/ssl/libssl.a  ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/lib
	cd ${dir}/${NGINX_INSTALL}
}
