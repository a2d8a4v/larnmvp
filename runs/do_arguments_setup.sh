#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function do_arguments_setup {
	## -- php7.3 or php7.4
	## default is 7.4
	readonly PHP_VER="7.4"
	# readonly PHP_VER="7.3"

	# boringssl or openssl
	## default is b
	readonly SSL_CONF="b"
	# readonly SSL_CONF="o"

	# use nginx from source or fork by Google
	## default is google
	# readonly NGINX_FROM="google"
	readonly NGINX_FROM="nginx"

	# is custom or not
	## default is yes
	# readonly IS_CUSTOM="yes"
	readonly IS_CUSTOM="no"

	# is beta version of WordPress
	## default is no
	readonly IS_BETA_WP="no"
	# readonly IS_BETA_WP="yes"

	# the version of WordPress
	## default is 5.3.2
	readonly WP_VER="5.3.2"
	# readonly WP_VER="5.2.2"

	# the version of Nginx
	readonly NGINX_VER="1.17.8"
	# readonly NGINX_VER="1.15.12"

	# the version of bazel
	## default is 0.21.0
	readonly BAZEL_VER="0.21.0"
	# readonly BAZEL_VER="0.22.0"

	# .htaccess, index.php, robots.txt install to WordPress root directory, default is yes, otherwise input other any or nothing, be seen as no.
	readonly HTA_ROT_IND_SAME_WP_RDIC="yes"

	## -- who am I ? the chroot of the user using this larnmvp
	readonly IT_WHOAMI="/"$(whoami)

	## -- for removing bad name for database name
	readonly badString="-"
	readonly goodString="_"

	## -- sshd config path
	# default is SSHD_GO=1
	# readonly SSHD_GO=0
	readonly SSHD_GO=1

	## -- for YannYann server can check this user is valid
	readonly BEGIN_YANN_SSL_KEY="-----BEGIN PRIVATE KEY-----"
	readonly END_YANN_SSL_KEY="-----END PRIVATE KEY-----"

	## -- controling for showing on screen or hide message
	readonly dnuloger="/dev/null"
	# readonly dnuloger="/dev/tty"
	# readonly dnuloger="/home/ubuntu/.larnmvp_process.txt"
	# @https://stackoverflow.com/questions/25635071/bash-redirect-to-screen-or-dev-null-depending-on-flag
}
