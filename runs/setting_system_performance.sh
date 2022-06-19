#!/bin/bash

function setting_system_performance {
	## -- BBR support TCP
	# @https://www.dcc.cat/bbr/
	# @https://blog.cloudflare.com/http-2-prioritization-with-nginx/
	### -- before enable BBR function, we should check the kernel version and should be bigger than 4.9 because of BBr was added after 4.9 version
	# if your system is higher than Ubuntu 17 or up, do not worry about the kernel version
	# check is bbr open or not
	# @https://github.com/teddysun/across/
	# @https://raw.githubusercontent.com/teddysun/across/master/bbr.sh
	# @https://hk.saowen.com/a/12720822ab1156770ee430d9a1d7163606edd812528446be194cb10495bf4642
	# @https://xiaozhou.net/enable-bbr-for-vps-2017-06-10.html
	# @https://xiaozhou.net/enable-bbr-for-vps-2017-06-10.html
	# @https://teddysun.com/489.html
	# @https://shazi.info/ubuntu-16-04-用-speedtest-cli-測試-tcp-bbr-效能/
	if [[ -z $(lsmod | grep bbr 2>&1) ]]; then
		modprobe tcp_bbr
		echo "tcp_bbr" >> /etc/modules
		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	fi

	### -- setting
	# @https://blog.longwin.com.tw/2013/02/nginx-add-worker_connections-2013/
	# for system numbers of max file
	cat ${INI}/system_ini/sysctl >> /etc/sysctl.conf
	
	### -- the amount of unsent data for sockets not using TCP_NOTSENT_LOWAT
	# @https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
	echo "net.ipv4.tcp_notsent_lowat=16384" >> /etc/sysctl.conf

	### -- 禁止 ICMP 封包
	# @https://www.yumao.name/read/linux-set-pass-icmp/
	echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
	echo "net.ipv4.icmp_echo_ignore_all=1" >> /etc/sysctl.conf

	# if [[ -f "/proc/sys/net/ipv4/tcp_tw_recycle" ]];then
	# 	echo "net.ipv4.tcp_tw_recycle=0" >> /etc/sysctl.conf
	# fi

	# modprobe ip_conntrack
	# @https://wiki.khnet.info/index.php/Conntrack_tuning
	# @https://blog.csdn.net/u010472499/article/details/78292811
	# 遇到 kernel nf_conntrack: table full, dropping packet 加入
	if [[ -f "/proc/sys/net/ipv4/netfilter/ip_conntrack_max" ]];then
		echo "net.ipv4.netfilter.ip_conntrack_max=655350" >> /etc/sysctl.conf
	fi

	if [[ -f "/proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established" ]];then
		echo "net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=1200" >> /etc/sysctl.conf
	fi

	### -- for soft and hard value
	if [[ -f "/etc/security/limits.conf" ]];then
		touch /etc/security/limits.conf
		echo "nginx soft nofile 655360" >> /etc/security/limits.conf
		echo "nginx hard nofile 655360" >> /etc/security/limits.conf
		echo "root soft nofile 100000" >> /etc/security/limits.conf
		echo "root hard nofile 200000" >> /etc/security/limits.conf
		echo "root soft memlock 100000" >> /etc/security/limits.conf
		echo "root hard memlock 200000" >> /etc/security/limits.conf
	fi

	## -- pam.d limits config setting
	# @https://www.itread01.com/content/1501938140.html
	if [[ -f "/etc/security/limits.conf" ]];then
		echo "session required pam_limits.so" >> /etc/pam.d/common-session
	fi

	### -- don't forget restart sysctl to make the all setting effect
	sysctl -p || echo

	## -- setting for nginx
	sed -i '/worker_processes/aworker_rlimit_nofile 102400;' /etc/nginx/nginx.conf
	service nginx reload

	## -- setting for resolved DNS
	sed -i '/^#DNS=/c\DNS= 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 7.7.7.7 9.9.9.9 74.82.42.42 66.220.18.42 8.26.56.26 8.20.247.20 64.6.64.6 64.6.65.6 156.154.70.1 156.154.71.1 216.146.36.36 216.146.35.35 209.244.0.3 209.244.0.4 23.253.163.53 198.101.242.72 203.80.96.10 202.45.84.58 202.14.67.4 202.14.67.14 208.67.222.222 208.67.220.220 168.95.1.1 168.95.192.1 139.175.252.16 139.175.55.244 101.101.101.101 101.102.103.104 168.126.63.1 168.126.63.2 210.220.163.82 219.250.36.130 164.124.101.2 203.248.252.2 164.124.107.9 203.248.242.2 77.88.8.8 77.88.8.1 195.46.39.39 195.46.39.40 84.200.69.80 84.200.70.40 77.109.148.136 77.109.148.137 91.239.100.100 89.233.43.71 80.80.80.80 80.80.81.81' /etc/systemd/resolved.conf
	mv /etc/resolv.conf /etc/resolv.confbak && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
	service systemd-resolved restart
}
