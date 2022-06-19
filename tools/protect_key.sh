#!/bin/bash

# algo.
# 1. openssl 唯一配對的 key 一副，本地保留公鑰匙，私密鑰匙傳送給我
# 2. openssl 的私鑰匙進行改造 -> 對這個進行驗證
# -- 傳送三把無意義的密碼 -> 配對這三個是否ㄧ樣
# -- 傳送一把有意義的密碼 -> 確認解碼後文字是否ㄧ樣

# 思考增加、刪除，部分刪除傳送過來之後、修改幾個字元
# 增加已經使用
# 替換字串

function _lines {
	printf "%s" "$(echo "$2-$1+1" | bc)"
}

function _getcontent {
	filename="$1"
	startline="$2"
	endline="$3"
	up_down="$4"

	i="$( grep -n -- "${startline}" "${filename}" | cut -d : -f 1 )"
	i=$(echo "$i+1" | bc)
	j="$( grep -n -- "${endline}" "${filename}" | cut -d : -f 1 )"
	j=$(echo "$j-1" | bc)

	l="$( _lines $j $i )"
	if [[ ${up_down} == "up" ]]; then
		# i do not have to change
		j=$(echo "$j/2+1" | bc)
	elif [[ ${up_down} == "down" ]]; then
		k=$(echo "$l%2" | bc)
		if (( $k == 0 )) || [[ -z $k ]]; then
			i=$(echo "$j/2+2" | bc)
			# j do not change
		elif (( $k == 1 )); then
			i=$(echo "$j/2+1" | bc)
			# j do not change
		fi
	fi

	sed -n "${i},${j}p" "${filename}"
}

function _mkpassword {
	echo -e "$(LC_CTYPE=C tr -dc A-Za-z0-9\/\+ < /dev/urandom | head -c $1)"
}

function _openpasswd {
	echo -n "$1" | sha256sum | awk '{print $1}'
}

function _md5passwd {
	echo "$1" | md5sum | awk '{print $1}'
}

function _perl_passwd {
	#echo "$1" | md5sum | awk '{print $1}'
	perl -MMIME::Base64 -e 'print encode_base64("\'${1}'\'${2}'")'
}

function _openssl_64_passwd {
	# e.g. 20121028ntu1928yannyann
	echo -n "$1" | openssl enc -e -base64
}

function protect_key {
	_filename=$(basename -- "$1")
	_yann_key_part="${_filename%.*}_part"
	_yann_key_mod="${_filename%.*}_mod.key"
	# 沒有意義的 key - 6
	_mkpassword_1=$( _mkpassword 64 > "$4"/${_yann_key_part}_1_rm.key )
	# 有意義的 key - 3
	_mkpassword_2=$( _openpasswd "19280316" > "$4"/${_yann_key_part}_1_get.key )
	# 沒有意義的 key - 4
	_mkpassword_3=$( _mkpassword 64 > "$4"/${_yann_key_part}_2_rm.key )
	# 有意義的 key - 1
	_mkpassword_4=$( echo -e "$( _md5passwd "yannyann" )$( _md5passwd "ntu200" )" > "$4"/${_yann_key_part}_2_get.key )
	# 替換用的 key - 8
	_mkpassword_5=$( _perl_passwd "yann2013" "0316yannyannyann" > "$4"/${_yann_key_part}_3_rm.key )
	# 有意義的 key - 7
	_mkpassword_6=$( _openssl_64_passwd "yannyannis20121028then20130901enrollintoNTUagec" > "$4"/${_yann_key_part}_4_get.key )
	# 上半部分 key - 2
	_a_ssl_content_up=$( _getcontent "$1" "$2" "$3" "up" > "$4"/${_yann_key_part}_4_rm.key )
	# 下半部分 key
	_a_ssl_content_down=$( _getcontent "$1" "$2" "$3" "down" > "$4"/${_yann_key_part}_5_rm.key )
	while read line;do
		if (( ${#line} == 32 )); then
			echo $line > "$4"/${_yann_key_part}_3_get.key
		else
			# - 5
			echo -e $line >> "$4"/${_yann_key_part}_6_rm.key
		fi
	done < "$4"/${_yann_key_part}_5_rm.key
	cat "$4"/${_yann_key_part}_2_get.key "$4"/${_yann_key_part}_4_rm.key "$4"/${_yann_key_part}_1_get.key "$4"/${_yann_key_part}_2_rm.key "$4"/${_yann_key_part}_6_rm.key "$4"/${_yann_key_part}_1_rm.key "$4"/${_yann_key_part}_4_get.key "$4"/${_yann_key_part}_3_rm.key > "$4"/${_yann_key_mod}
}
