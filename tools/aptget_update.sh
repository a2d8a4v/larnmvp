#!/bin/bash

function aptget_update {
	apt-get -qq update
	apt-get -qq upgrade
}
