#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_from_google {
	## -- setting for arguments
	check_point
	NGINX_INSTALL="nginx_install"
	mkdir -p -v ${dir}/${NGINX_INSTALL} && cd ${dir}/${NGINX_INSTALL}
	git clone https://nginx.googlesource.com/nginx ${dir}/${NGINX_INSTALL}/nginx
	cd ${dir}/${NGINX_INSTALL}/nginx
	export PATH="$PATH:$HOME/bin"
	if bazel build :nginx-google.deb;then
		#@@@ Until the next stable version, first thing we should do is get the compiled deb in order to avoid from the fail condition from bazel
		mkdir -p -v ${dir}/${NGINX_INSTALL}/nginx/deb/
		cp ${dir}/${NGINX_INSTALL}/nginx/bazel-bin/nginx-google_*.deb ${dir}/${NGINX_INSTALL}/nginx/deb/
		mv -f ${dir}/${NGINX_INSTALL}/nginx/deb/nginx-google_*.deb ${dir}/${NGINX_INSTALL}/nginx/deb/nginx-google.deb
		dpkg -i ${dir}/${NGINX_INSTALL}/nginx/deb/nginx-google.deb
	else
		dpkg -i ${INI}/nginx_ini/deb/nginx-google_*.deb
	fi

	# go back to root
	cd ${dir}
}

function install_from_source {
	## -- setting for arguments
	check_point
	NGINX_INSTALL="nginx_install"
	OPEN_BORING_SSL_DIR="ob_ssl"
	mkdir ${dir}/${NGINX_INSTALL} && cd ${dir}/${NGINX_INSTALL}

	## -- install boringssl or openssl
	if [[ ${NGINX_FROM} == "nginx" ]];then
		if [[ ${SSL_CONF} == "b" ]];then
			install_boringssl
		elif [[ ${SSL_CONF} == "o" ]];then
			install_openssl
		else
			install_boringssl
		fi
	elif [[ ${NGINX_FROM} == "google" ]];then
		echo "nothing to do."
	else
		# default use boringssl
		install_boringssl
	fi

	# @https://dcc.cat/nginx/
	## -- install libbrotli
	git clone https://github.com/bagder/libbrotli ${dir}/${NGINX_INSTALL}/libbrotli
	# enter in
	cd ${dir}/${NGINX_INSTALL}/libbrotli
	./autogen.sh && ./configure && make -j$(nproc --all) && make install
	# go back to nginx install root
	cd ${dir}/${NGINX_INSTALL}

	## -- brotli for nginx
	# google does not support ngx_brotli for a long time, we change to use the new version support by member in Google, INC
	# https://github.com/google/ngx_brotli.git
	git clone https://github.com/eustas/ngx_brotli ${dir}/${NGINX_INSTALL}/ngx_brotli
	# enter in
	cd ${dir}/${NGINX_INSTALL}/ngx_brotli
	git submodule update --init
	# go back to nginx install root
	cd ${dir}/${NGINX_INSTALL}

	## -- zlib
	git clone https://github.com/cloudflare/zlib ${dir}/${NGINX_INSTALL}/zlib
	cd ${dir}/${NGINX_INSTALL}/zlib
	./configure
	cd ${dir}/${NGINX_INSTALL}

	## -- prce
	wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz -O ${dir}/${NGINX_INSTALL}/pcre.tar.gz
	tar zxf ${dir}/${NGINX_INSTALL}/pcre.tar.gz --directory=${dir}/${NGINX_INSTALL} && rm -rf ${dir}/${NGINX_INSTALL}/pcre.tar.gz && mv ${dir}/${NGINX_INSTALL}/pcre*-* ${dir}/${NGINX_INSTALL}/pcre
	cd ${dir}/${NGINX_INSTALL}/pcre
	./configure && make -j$(nproc --all) && make install
	mkdir -p -v ${dir}/${NGINX_INSTALL}/pcre/.libs
	cp /usr/local/lib/libpcre.a ${dir}/${NGINX_INSTALL}/pcre/libpcre.a
	cp /usr/local/lib/libpcre.la ${dir}/${NGINX_INSTALL}/pcre/libpcre.la
	cp /usr/local/lib/libpcre.a ${dir}/${NGINX_INSTALL}/pcre/.libs/libpcre.a
	cp /usr/local/lib/libpcre.la ${dir}/${NGINX_INSTALL}/pcre/.libs/libpcre.la
	cd ${dir}/${NGINX_INSTALL}

	## -- install libatomic_ops
	git clone https://github.com/ivmai/libatomic_ops.git ${dir}/${NGINX_INSTALL}/libatomic_ops
	cd ${dir}/${NGINX_INSTALL}/libatomic_ops
	./autogen.sh && ./configure && make -j$(nproc --all) && make install
	ldconfig
	cd ${dir}/${NGINX_INSTALL}

	## -- lib MAXMIND install for ngx_http_geoip2_module
	# MAXMIND_INSTALL_PATH=/usr/share/maxmind
	# MAXMIND_LIB_PATH=${MAXMIND_INSTALL_PATH}/lib
	# MAXMIND_INC_PATH=${MAXMIND_INSTALL_PATH}/include
	# wget https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz -O ${dir}/${NGINX_INSTALL}/libmaxminddb.tar.gz
	# tar xzf ${dir}/${NGINX_INSTALL}/libmaxminddb.tar.gz && rm -rf ${dir}/${NGINX_INSTALL}/libmaxminddb.tar.gz && mv ${dir}/${NGINX_INSTALL}/libmaxminddb-* ${dir}/${NGINX_INSTALL}/libmaxminddb
	# cd ${dir}/${NGINX_INSTALL}/libmaxminddb
	# ./configure --prefix=${MAXMIND_INSTALL_PATH} && make -j$(nproc --all) && make install
	# echo "${MAXMIND_LIB_PATH}" > /etc/ld.so.conf.d/libmaxminddb.conf
	# ldconfig -v 2>/dev/null |grep -i maxmind
	# cd ${dir}/${NGINX_INSTALL}

	## -- jemalloc
	git clone https://github.com/jemalloc/jemalloc.git ${dir}/${NGINX_INSTALL}/jemalloc
	cd ${dir}/${NGINX_INSTALL}/jemalloc
	./autogen.sh && make -j$(nproc --all)
	touch doc/jemalloc.html & touch doc/jemalloc.3
	make install
	echo '/usr/local/lib' | tee /etc/ld.so.conf.d/local.conf
	ldconfig
	cd ${dir}/${NGINX_INSTALL}

	## -- nginx-rtmp-module
	git clone https://github.com/arut/nginx-rtmp-module.git ${dir}/${NGINX_INSTALL}/ngx-rtmp-module

	## -- headers-more-nginx-module
	git clone https://github.com/openresty/headers-more-nginx-module.git ${dir}/${NGINX_INSTALL}/headers-more-nginx-module

	## -- ngx_http_geoip2_module
	# @https://github.com/leev/ngx_http_geoip2_module
	git clone https://github.com/leev/ngx_http_geoip2_module.git ${dir}/${NGINX_INSTALL}/ngx_http_geoip2_module

	## -- nginx-sorted-querystring-module
	# @https://github.com/wandenberg/nginx-sorted-querystring-module
	git clone https://github.com/wandenberg/nginx-sorted-querystring-module.git ${dir}/${NGINX_INSTALL}/ngx-sorted-querystring-module

	## -- nginx-dav-ext-module
	# @https://github.com/arut/nginx-dav-ext-module
	git clone https://github.com/arut/nginx-dav-ext-module.git ${dir}/${NGINX_INSTALL}/ngx-dav-ext-module

	## -- nginx_requestid
	# @https://github.com/hhru/nginx_requestid
	git clone https://github.com/hhru/nginx_requestid.git ${dir}/${NGINX_INSTALL}/ngx_requestid

	## -- the most famous module in Nginx world -- lua-nginx-module
	# @https://github.com/openresty/lua-nginx-module.git
	git clone https://github.com/openresty/lua-nginx-module.git ${dir}/${NGINX_INSTALL}/lua-nginx-module
	#--add-module=../lua-nginx-module \

	## -- install libunwind to support gperftools in 64bit computer
	# @https://github.com/dropbox/libunwind
	# @http://download.savannah.nongnu.org/releases/libunwind/
	wget http://download.savannah.nongnu.org/releases/libunwind/libunwind-1.3.1.tar.gz -O ${dir}/${NGINX_INSTALL}/libunwind.tar.gz
	# wget http://download.savannah.nongnu.org/releases/libunwind/libunwind-1.3.1.tar.gz -O ${dir}/${NGINX_INSTALL}/libunwind.tar.gz
	tar zxf ${dir}/${NGINX_INSTALL}/libunwind.tar.gz --directory=${dir}/${NGINX_INSTALL} && rm -rf ${dir}/${NGINX_INSTALL}/libunwind.tar.gz && mv ${dir}/${NGINX_INSTALL}/libunwind-* ${dir}/${NGINX_INSTALL}/libunwind
	cd ${dir}/${NGINX_INSTALL}/libunwind
	./configure && make -j$(nproc --all) && make install
	cd ${dir}/${NGINX_INSTALL}

	## -- install gperftools to tweak nginx speed
	# @https://github.com/gperftools/gperftools/releases
	# @https://v5b7.com/INBOX/nginx/nginx_with_google_perftools/nginx_with_google_perftools.html
	# @https://www.jb51.net/article/34016.htm
	# @https://my.oschina.net/ambari/blog/664786
	wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.7/gperftools-2.7.tar.gz -O ${dir}/${NGINX_INSTALL}/gperftools.tar.gz
	tar zxf ${dir}/${NGINX_INSTALL}/gperftools.tar.gz --directory=${dir}/${NGINX_INSTALL} && rm -rf ${dir}/${NGINX_INSTALL}/gperftools.tar.gz && mv ${dir}/${NGINX_INSTALL}/gperftools-* ${dir}/${NGINX_INSTALL}/gperftools
	cd ${dir}/${NGINX_INSTALL}/gperftools
	./configure && make -j$(nproc --all) && make install
	cd ${dir}/${NGINX_INSTALL}
	mkdir -p -v /usr/lib64/
	ln -s /usr/local/lib/libprofiler.so.0 /usr/lib64/libprofiler.so.0
	ln -s /usr/local/lib/libunwind.so.8 /usr/lib64/libunwind.so.8
	ln -s /usr/local/lib/libprofiler.so.0  /usr/lib/libprofiler.so.0
	ln -s /usr/local/lib/libunwind.so.8 /usr/lib/libunwind.so.8

	## -- download and install nginx
	wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O ${dir}/${NGINX_INSTALL}/nginx.tar.gz
	tar zxf ${dir}/${NGINX_INSTALL}/nginx.tar.gz --directory=${dir}/${NGINX_INSTALL} && rm -rf ${dir}/${NGINX_INSTALL}/nginx.tar.gz && mv ${dir}/${NGINX_INSTALL}/nginx-* ${dir}/${NGINX_INSTALL}/nginx
	cd ${dir}/${NGINX_INSTALL}/nginx
	# SPDY, HTTP2 HPACK, Dynamic TLS Record, Fix Http2 Push Error Patch
	# @https://github.com/kn007/patch
	curl https://raw.githubusercontent.com/kn007/patch/d6bd9f7e345a0afc88e050a4dd991a57b7fb39be/nginx.patch | patch -p1
	# Strict-SNI Patch
	# Strict SNI requires at least two ssl server (fake) settings (server { listen 443 ssl }).
	# It does not matter what kind of certificate or duplicate.
	curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_strict-sni_1.15.10.patch | patch -p1
	# I/O uring for Kernel 5.1 support
	curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_io_uring.patch | patch -p1

	# enter in nginx install root
	cd ${dir}/${NGINX_INSTALL}/nginx

	# @https://moa.moe/264
	# @https://haohetao.iteye.com/blog/2378660
	# @https://designhost.gr/topic/799-enabling-tcp-fast-open-for-nginx-on-centos-7/
	# @http://nginx.org/en/docs/configure.html
	# @https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc/
	# @https://serverfault.com/questions/869794/nginx-with-cc-opt-and-with-ld-opt-configure-options
	# @https://love4taylor.me/posts/nginx-tls-1-3/

	./configure --prefix=/etc/nginx  \
	            --sbin-path=/usr/sbin/nginx \
	            --modules-path=/usr/lib64/nginx/modules \
	            --conf-path=/etc/nginx/nginx.conf \
	            --error-log-path=/var/log/nginx/error.log \
	            --http-log-path=/var/log/nginx/access.log \
	            --pid-path=/var/run/nginx.pid \
	            --lock-path=/var/run/nginx.lock \
	            --http-client-body-temp-path=/var/lib/nginx/body \
	            --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
	            --http-proxy-temp-path=/var/lib/nginx/proxy \
	            --http-scgi-temp-path=/var/lib/nginx/scgi \
	            --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
	            --user=nginx \
	            --group=nginx \
	            --build=Yannyann.com \
	            --with-openssl=../${OPEN_BORING_SSL_DIR} \
	            --with-openssl-opt='enable-tls1_3 enable-ec_nistp_64_gcc_128 enable-weak-ssl-ciphers zlib -march=native -ljemalloc -Wl,-flto' \
	            --with-mail \
	            --with-debug \
	            --with-compat \
	            --with-threads \
	            --with-libatomic \
	            --with-zlib=../zlib \
	            --with-pcre=../pcre \
	            --with-pcre-jit \
	            --with-stream \
	            --with-poll_module \
	            --with-select_module \
	            --with-http_v2_module \
	            --with-http_dav_module \
	            --with-mail_ssl_module \
	            --with-http_flv_module \
	            --with-http_sub_module \
	            --with-http_mp4_module \
	            --with-http_dav_module \
	            --with-http_ssl_module \
	            --with-http_xslt_module \
	            --with-http_slice_module \
	            --with-stream_ssl_module \
	            --with-http_gunzip_module \
	            --with-http_realip_module \
	            --with-stream_geoip_module \
	            --with-http_addition_module \
	            --with-stream_realip_module \
	            --with-http_stub_status_module \
	            --with-http_gzip_static_module \
	            --with-http_secure_link_module \
	            --with-http_degradation_module \
				--with-google_perftools_module \
	            --with-http_random_index_module \
	            --with-http_auth_request_module \
	            --with-http_image_filter_module \
	            --with-stream_ssl_preread_module \
	            --add-module=../ngx_brotli \
	            --add-module=../ngx_requestid \
	            --add-module=../ngx-rtmp-module \
	            --add-module=../ngx-dav-ext-module \
	            --add-module=../ngx-sorted-querystring-module \
	            --add-module=../headers-more-nginx-module \
	            --with-cc-opt='-g -O3 -m64 -march=native -ffast-math -DTCP_FASTOPEN=23 -fPIE -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wno-unused-parameter -fno-strict-aliasing -fPIC -D_FORTIFY_SOURCE=2 -gsplit-dwarf' \
	            --with-ld-opt='-lrt -L /usr/local/lib -ljemalloc -Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,now -fPIC'
# --with-file-aio \
# --with-http_v2_hpack_enc \
# --add-module=../ngx_http_geoip2_module
# --add-module=../nginx-module-vts
# --add-module=../ngx_devel_kit-0.3.0
# --add-module=../set-misc-nginx-module-0.32
# --add-module=../echo-nginx-module
# --add-module=../redis2-nginx-module-0.15
# --add-module=../ngx_http_redis-0.3.7
# --add-module=../memc-nginx-module-0.18
# --add-module=../srcache-nginx-module-0.31
# --add-module=../ModSecurity-nginx

	# should touch a time pin for boringssl before make nginx
	if [[ ${NGINX_FROM} == "nginx" ]];then
		if [[ ${SSL_CONF} == "b" ]];then
			touch ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/include/openssl/ssl.h
		elif [[ ${SSL_CONF} == "o" ]];then
			echo "nothing to do."
		else
			touch ${dir}/${NGINX_INSTALL}/${OPEN_BORING_SSL_DIR}/.openssl/include/openssl/ssl.h
		fi
	elif [[ ${NGINX_FROM} == "google" ]];then
		echo "nothing to do."
	else
		# default use boringssl but nginx-google have boringssl already
		echo "nothing to do."
	fi

	## start install nginx
	make -j$(nproc --all) && make install
	
	# go back to root
	cd ${dir}
}

function install_nginx_run {
	if [[ ${NGINX_FROM} == "nginx" ]];then
		install_from_source
	elif [[ ${NGINX_FROM} == "google" ]];then
		install_from_google
	else
		# default use source
		install_from_source
	fi
}

function install_nginx_no_run {
	echo "no run."
}

function install_nginx {
	## -- edit linux core for tcp fast open
	sysctl -w net.ipv4.tcp_fastopen=3
	echo "net.ipv4.tcp_fastopen=3" >> /etc/sysctl.conf
	echo 3 > /proc/sys/net/ipv4/tcp_fastopen
	sysctl -p

	## -- install nginx from source or google verison
	TEST_CADDY_NGINX=$( lower_case ${CADDY_NGINX} )
	if [[ ${TEST_CADDY_NGINX} == "nginx" ]]; then
		install_nginx_run
	elif [[ ${TEST_CADDY_NGINX} == "caddy" ]]; then
		install_nginx_no_run
	else
		install_nginx_run
	fi
}
