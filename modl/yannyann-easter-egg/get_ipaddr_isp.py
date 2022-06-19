#!/usr/bin/env python
#coding:utf-8
import sys,urllib2,socket,json
try:
  socket.setdefaulttimeout(5)
  if len(sys.argv) == 1:
    apiurl = "http://ip-api.com/json"
  elif len(sys.argv) == 2:
    apiurl = "http://ip-api.com/json/%s" % sys.argv[1]
  content = urllib2.urlopen(apiurl).read()
  content = json.JSONDecoder().decode(content)
  if content['status'] == 'success':
    print(content['isp'])
  else:
    print("NO")
except:
  print("Usage:%s IP" % sys.argv[0])
