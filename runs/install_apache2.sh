#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function install_apache2 {
	apt-get -qq install apache2 apache2-utils libapache2-mod-php${PHP_VER} libapache2-mod-fcgid
}
