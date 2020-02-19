vcl 4.0;

backend default {
    .host = "127.0.0.1";
    .port = "yannyann_apache2_portsconf";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
    .max_connections = 200;
}

acl purge {
  "localhost";
  "127.0.0.1";
}

import std;
include "/etc/varnish/conf.d/devicedetect.vcl";

sub vcl_recv {
    //**insert_www_or_nonwww_varnish_yannyann*//

    # set https
    # @https://wiki.deimos.fr/Nginx_+_Varnish_:_Cache_even_in_HTTPS_by_offloading_SSL.html
    # @http://virajgwiki.blogspot.com/2014/10/varnish-redirecting-examples-using-vcl.html
    # @https://www.stackstar.com/blog/2015/04/force-ssl-for-your-site-with-varnish-and-nginx/
    # if (req.http.X-Forwarded-Proto !~ "(?i)https" && req.http.host ~ "^(?i)yannyann_web_domain$" || req.http.host ~ "^(?i)www.yannyann_web_domain$" ) {
    //**insert_www_or_nonwww_varnish_2_yannyann*//
      set req.http.x-redir = "https://" + req.http.host + req.url;
      return(synth(301));
    }

    # set for device in order to seperate cache
    call devicedetect;

    ## -- Default request checks
    # This makes sure the POST requests are always passed.
    # req.request has been renamed to req.method
    if (req.method != "GET" &&
      req.method != "HEAD" &&
      req.method != "PUT" &&
      req.method != "POST" &&
      req.method != "TRACE" &&
      req.method != "OPTIONS" &&
      req.method != "DELETE") {
        /* Non-RFC2616 or CONNECT which is weird. */
        return (pipe);
    }
    if (req.method != "GET" && req.method != "HEAD") {
        /* We only deal with GET and HEAD by default */
        return (pass);
    }
    if (req.http.Authorization) {
        /* Not cacheable by default */
        return (pass);
    }

    

    if (req.url ~ "/feed") {
      return (pass);
    }

    if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true" || req.url ~ "(xmlrpc.php|wp-cron.php)") {
      return (pass);
    }

    if (req.http.Cookie ~ "wordpress_logged_in_") {
      return (pass);
    }

    set req.http.cookie = regsuball(req.http.cookie, "wp-settings-\d+=[^;]+(; )?", "");
    set req.http.cookie = regsuball(req.http.cookie, "wp-settings-time-\d+=[^;]+(; )?", "");
    set req.http.Cookie = regsuball(req.http.Cookie, "wordpress_test_cookie=[^;]+(; )?", "");

    if (req.url ~ "/(cart|my-account|checkout|addons|/?add-to-cart=)") {
      return (pass);
    }

    if (req.http.cookie == "") {
      unset req.http.cookie;
    }

    if (req.http.cookie ~ "^ *$") {
      unset req.http.cookie;
    }

    if (req.url ~ "\.(gif|jpg|jpeg|swf|ttf|flv|mp3|mp4|pdf|ico|png)(\?.*|)$") {
      unset req.http.cookie;
    }

    if (req.http.Cookie ~ "wordpress_" || req.http.Cookie ~ "comment_") {
      return (pass);
    }

    if (!req.http.cookie) {
      unset req.http.cookie;
    }

    if( req.url ~ "^/$" ) {
      return (hash);
    }

    ## -- purge
    if (req.method == "PURGE") {
      if (req.method == "PURGE") {
        if (std.ip(req.http.x-real-ip, "0.0.0.0") ~ purge) {
          return (purge);
        } else {
          return (synth(403));
        }
      }
    }

    return (hash);
}

sub vcl_pipe {
    return (pipe);
}

sub vcl_pass {
    return (fetch);
}

sub vcl_hash {
    hash_data(req.url);
    if (req.http.host) {
      hash_data(req.http.host);
    } else {
      hash_data(server.ip);
    }
    hash_data(req.http.X-UA-Device);
    return (lookup);
}

sub vcl_backend_response {
    if (bereq.url ~ "\.(png|gif|jp(e?)g|swf|ico)") {
      unset beresp.http.cookie;
    }
    if ( bereq.method == "POST" || bereq.http.Authorization ) {
      set beresp.uncacheable = true;
      set beresp.ttl = 120s;
      return (deliver);
    }
    if ( bereq.url ~ "\?s=" ){
      set beresp.uncacheable = true;
      set beresp.ttl = 120s;
      return (deliver);
    }
    if ( beresp.status != 200 ) {
      set beresp.uncacheable = true;
      set beresp.ttl = 120s;
      return (deliver);
    }
    if (beresp.ttl == 150s) {
      set beresp.ttl = 2h;
    }
    set beresp.ttl = 1h;
    set beresp.grace = 30s;
    return (deliver);
}

sub vcl_deliver {
    if (req.http.X-Purger) {
      set resp.http.X-Purger = req.http.X-Purger;
    }
    if (obj.hits > 0) {
      set resp.http.X-Cache = "Hit";
    } else {
      set resp.http.x-Cache = "Miss";
    }
    #set resp.http.X-Cache-Hits = obj.hits;
    unset resp.http.Via;
    set resp.http.Via = "yannyann_varnish_who_cache";
    unset resp.http.X-Varnish;
    unset resp.http.Server;
    # Remove some headers - PHP
    unset resp.http.X-Powered-By;
    return (deliver);
}

sub vcl_synth {
    if (resp.status == 301) {
      set resp.http.Location = req.http.x-redir;
      return(deliver);
    }
}

sub vcl_purge {
    set req.method = "GET";
    set req.http.X-Purger = "Purged";
    return (restart);
}

sub vcl_init {
     return (ok);
}

sub vcl_fini {
     return (ok);
}