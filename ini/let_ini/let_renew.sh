#!/bin/bash

# close the bot-block funtion first
cp -f /etc/varnish/yannyann_varnish_default /etc/varnish/yannyann_varnish_defaultbak
sed -i 's/.*bad_bot.vcl/#&/;s/.*bad_ip.vcl/#&/;s/.*call bad_bot/#&/;s/.*call unwa_ips/#&/' /etc/varnish/yannyann_varnish_default
service varnish restart

# update ssl
/usr/bin/certbot renew --quiet --no-self-upgrade --post-hook "service nginx reload"

# restore varnish
mv -f /etc/varnish/yannyann_varnish_defaultbak /etc/varnish/yannyann_varnish_default
service varnish restart
exit
