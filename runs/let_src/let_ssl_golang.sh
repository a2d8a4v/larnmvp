#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function let_ssl_golang {
	# @https://medium.com/@patdhlk/how-to-install-go-1-9-1-on-ubuntu-16-04-ee64c073cd79
	# @https://stackoverflow.com/questions/25216765/gobin-not-set-cannot-run-go-install
	GO_DIR="golang"
	if [[ -f "/usr/bin/go" ]] || [[ -d "/usr/bin/go" ]];then
		mv -f /usr/bin/go /usr/bin/go_bak
	fi
	mkdir -p -v ${dir}/${GO_DIR}
	# wget https://storage.googleapis.com/golang/go1.10.4.linux-amd64.tar.gz -O ${dir}/golang.tar.gz
	wget https://storage.googleapis.com/golang/go1.12.linux-amd64.tar.gz -O ${dir}/golang.tar.gz
	tar zxf ${dir}/golang.tar.gz --directory=${dir}/${GO_DIR}

	# move to install root dicrectory
	GET_NOW_DIC="$PWD"
	cd ${dir}

	# setting for the root of golang directory
	export GOROOT=${dir}/${GO_DIR}/go
	export GOPATH=${dir}/${GO_DIR}/work
	export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
	mkdir -p -v ${dir}/${GO_DIR}/work/src/yannyannplay

	# move the program
	## should create a directory in work and one more src directory
	mv -f ${INI}/let_ini/let_other.go ${dir}/${GO_DIR}/work/src/yannyannplay
	
	# use gin-framework
	# @https://github.com/gin-gonic/gin
	# it can only use golang 1.10.4
	go get -u golang.org/x/crypto/acme/autocert
	go get -u golang.org/x/net/http2
	go install yannyannplay

	# start to run program to let programe to get key and produce fullchain key file and privkey file
	## use '&' let program run in background
	${GOPATH}/bin/yannyannplay &
	local _TMP=$!
	wait ${_TMP}
	if curl https://${website}; sleep 5s && kill -9 ${_TMP} ;then
		# start to move key place for nginx use
		# after get the key, create letsencrypt directory
		while true; do
			if [[ -e "${dir}/${GO_SSL_CERT_DIC}/acme_account+key" ]] && [[ -e "${dir}/${GO_SSL_CERT_DIC}/${website}" ]];then
				echo "
Congratulations!
/etc/letsencrypt/live/${website}/fullchain.pem
/etc/letsencrypt/live/${website}/privkey.pem" >> ${dir}/let_tmp.txt
				break 1
			else
				echo "waiting..."
			fi
		done
		mkdir -p -v /etc/letsencrypt/live/${website}
		mv -f ${dir}/${GO_SSL_CERT_DIC}/acme_account+key /etc/letsencrypt/live/${website}/privkey.pem
		mv -f ${dir}/${GO_SSL_CERT_DIC}/${website} /etc/letsencrypt/live/${website}/fullchain.pem
	else
		"nothing to do."
	fi

	# go back to the original directory
	cd ${GET_NOW_DIC}
}
