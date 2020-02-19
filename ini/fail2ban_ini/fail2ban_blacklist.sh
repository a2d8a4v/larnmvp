#!/bin/bash

#######################
##                   ##
##   Version 0.01    ##
##                   ##
#######################

## --- some preforward setting
# working even if somebody run "sh larnmvp.sh"
set -e
# talosintelligence automatically update ip-blacklist
readonly talosblaipli="/opt/fail2ban/ip_talos.txt"
readonly talosblaiplitp="/opt/fail2ban/ip_talos_tp.txt"
readonly badipsli="/opt/fail2ban/ip_badip.txt"
readonly f2blali="/etc/fail2ban/ip.blacklist"
readonly new="/opt/fail2ban/new_ip.txt"
readonly v_new="/etc/varnish/conf.d/bad_ip.vcl"
TIME=$(date +%Y%m%d_%H%M%S)
backuptime="/etc/varnish/backuptime"
varnishdefault="/etc/varnish/yannyann_varnish_default"

if [[ -e "/etc/varnish/secret" ]];then
	VARNISHADM="varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082"
else
	VARNISHADM="varnishadm -T 127.0.0.1:6082"
fi


## --- check is ubuntu
readonly ee_linux_distro=$(lsb_release -i | awk '{print $3}')
if [ "$ee_linux_distro" != "Ubuntu" ]; then
	echo "It can only be used on Ubuntu 18.04 or up."
	exit 1
fi

## --- check if installed fail2ban or varnish
if ! command -v varnishd ; then
	echo "You should install Varnish first."
	exit 1
fi
if ! command -v fail2ban-client ; then
	echo "You should install fail2ban first."
	exit 1
fi
if ! $VARNISHADM vcl.list >> /dev/null 2>&1; then
        echo "Unable to run \"$VARNISHADM vcl.list\""
        exit 1
fi

## --- update the blacklist data
# get list from talosintelligence
mkdir -p -v /opt/fail2ban
touch {${talosblaipli},${badipsli}}
wget -q https://www.talosintelligence.com/documents/ip-blacklist -O $talosblaiplitp
# clean the data
while read lineip1; do
	echo ${lineip1} | grep -P --quiet '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
	[ $? -eq 0 ] && sed -i "\$a${lineip1}" ${talosblaipli}
done < $talosblaiplitp

# get list from badips
curl -s 'https://www.badips.com/get/list/wordpress/' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36' --compressed -o ${badipsli}

## --- fail2ban part
# first, make the new ip blacklist for fail2ban, combine the download list into
cat $talosblaipli $badipsli >> $f2blali
awk '!a[$0]++' $f2blali | sed '/^[[:space:]]*$/d' > /etc/fail2ban/ip.blacklisttmp && mv -f /etc/fail2ban/ip.blacklisttmp $f2blali

## --- varnish part
# edit the list, append like ""; or :port.
sed '/^[[:space:]]*$/d;s/^/"/;s/$/";/' $talosblaipli > /opt/fail2ban/ip_talos_mod.txt
if [[ -e $f2blali ]]; then
	cp -f $f2blali /opt/fail2ban/f2b_ip_ori.txt
	sed '/^[[:space:]]*$/d;s/^/"/;s/$/";/' /opt/fail2ban/f2b_ip_ori.txt > /opt/fail2ban/f2b_ip_mod.txt
fi
# combine two files
touch $new && cat /opt/fail2ban/f2b_ip_mod.txt /opt/fail2ban/ip_talos_mod.txt >> $new
awk '!a[$0]++' $new > /opt/fail2ban/new_ip_2.txt
sed -i 's/^/    /' /opt/fail2ban/new_ip_2.txt
# add vcl language to new file
# the first line
sed -i '1 i\acl unwanted {' /opt/fail2ban/new_ip_2.txt
# the end of file
sed -i "\$a}" /opt/fail2ban/new_ip_2.txt
# add the sub
# sed -i "\$asub unwa_ips { \n    if (client.ip ~ unwanted) {\n        return(synth(403, 'No way.'));\n    }\n}" /opt/fail2ban/new_ip_2.txt
echo -e '\nsub unwa_ips { \n    if (client.ip ~ unwanted) {\n        return(synth(403, "No way."));\n    }\n}' >> /opt/fail2ban/new_ip_2.txt
# @https://askubuntu.com/questions/702677/how-to-insert-multiple-lines-with-sed
# @https://ma.ttias.be/reload-varnish-vcl-without-losing-cache-data/
# move the file to varnish config
mv -f /opt/fail2ban/new_ip_2.txt $v_new
# cleanup all the temparary files
rm -f /opt/fail2ban/*.txt

## --- make varnish reload without losing caching data
# get the first line which line is used now, at least there will be one active
# nvcl_use=$($VARNISHADM vcl.list | sed '/^[[:space:]]*$/d' | awk '{sub(/([^ ]+ +){3}/,"")}1' | head -1 )
nvcl_use=$( $VARNISHADM vcl.list | awk ' /^active/ { print $4 } ' )
new_vcl="varnish_${TIME}"
# check what vcl is used now, and we make a new file and add the using vcl before the first line of file
if [[ ! -e $backuptime ]] || [[ $nvcl_use == "boot" ]]; then
	touch $backuptime && echo $nvcl_use >> $backuptime
	sed -i '1 i\$new_vcl' $backuptime
else
	sed -i '1 i\$new_vcl' $backuptime
fi
# load the vcl config file to the memory, use new vcl config file
$VARNISHADM vcl.load $new_vcl ${varnishdefault}
# @https://stackoverflow.com/questions/26508138/split-a-sentence-using-space-in-bash-script
# use new vcl config file
$VARNISHADM vcl.use $new_vcl
# discard the old running vcl config file
$VARNISHADM vcl.discard $nvcl_use

## --- restart all the services
# do not restart or reload varnish
service fail2ban restart
exit
