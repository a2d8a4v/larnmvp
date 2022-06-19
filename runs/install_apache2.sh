#!/bin/bash

function install_apache2 {
	apt-get -qq install apache2 apache2-utils libapache2-mod-php${PHP_VER} libapache2-mod-fcgid
}
