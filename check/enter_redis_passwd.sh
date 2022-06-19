#!/bin/bash

function enter_redis_passwd {
	while read -p "@@ Enter password of Redis: " redispasswd; do
		if [[ ${redispasswd} =~ [[:blank:]] ]];then
			echo "Can only input without space, try do it again!"
		elif [[ -z ${redispasswd} ]]; then
			echo "You input nothing, do it again!"
		else
			echo "--Your password of Redis is ${redispasswd}"
			break
		fi
	done
}
