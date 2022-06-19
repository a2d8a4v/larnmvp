#!/bin/bash

function do_showing {
	echo "
	You have those settings -----------------------------------------------------

	Install Website : ${website}
	Your Domain name : ${domain}
	Your website root diterory : ${SITE_DIR}
	Your Apache2 using port : ${apaport}
	Your Apache2 default file name : /etc/apache2/sites-available/${apache2default}
	Your Varnish using port : ${varnport}
	Your Varnish default file name : /etc/varnish/${varnishdefault}
	Your Nginx using port : 443
	Your Nginx default file name : /etc/nginx/sites-available/${nginxdefault}
	Your SFTP port : ${sftpport}

	------------------------------------------------------------------------------
	"
	echo "### Waiting for 5s and then start to install"
	sleep 5s
}
