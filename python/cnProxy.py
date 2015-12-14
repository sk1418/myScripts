#!/usr/bin/python2
###################################################
# fetch China (default top 5) Proxies from http://proxy-list.org/
#
# If argument N was given, take as top N
# Dependencies: BeautifulSoup4 and requests
#
# Author : Kent 2015-11-04
# Email  : kent dot yuan at gmail dot com.
# 
# update 2015-12-14  proxy-list.org has ip:port base64 encrypted....
###################################################
# -*- coding: utf-8 -*-

import sys, re, requests
from bs4 import BeautifulSoup
import base64

PROXY_POOL_URL = 'http://proxy-list.org/english/search.php?search=CN&country=CN&type=any&port=any&ssl=any&p=%d'

class Proxy(object):
    def __init__(self, value, speed):
        self.value = value
        self.speed = speed

    def print_proxy(self):
        clear = u'\x1b[0m'
        style={
            'red':u'\x1b[31;1m',
            'green':u'\x1b[34m'
            }
        print '%s%s\t%s%skb%s' % (style["green"],self.value, style["red"], self.speed, clear)


def parse_proxies():
    page = 1
    #empty list
    proxies = []
    while True:
        html = requests.get(PROXY_POOL_URL%page).text
        table = BeautifulSoup(html, 'html.parser').find(id="proxy-table")
        proxy_tags = table.find_all('script', text=re.compile(r'^\s*Proxy\s*\('))
        speed_tags = table.find_all('li',class_='speed', text=re.compile((r'[0-9.]k.*|-')))
        if not proxy_tags:
            break
        for speed_tag in speed_tags:
            speed = re.sub(r'kb.*','',speed_tag.string.strip())
            if re.match(r'[0-9.]+',speed) and float(speed) > 50:
                proxy_tag = proxy_tags[speed_tags.index(speed_tag)]
                proxy_server = base64.b64decode(re.split(r"[\"\']",proxy_tag.string)[1])
                proxies.append(Proxy(proxy_server, float(speed)))
        page += 1
    if proxies:
        return sorted(proxies,key=lambda x : x.speed, reverse=True)


if __name__ == '__main__':
    n = 5 if len(sys.argv)<2 or int(sys.argv[1])<=0 else int(sys.argv[1])
    proxies = parse_proxies()
    n = len(proxies) if len(proxies) < n else n
    for p in proxies[:n]:
        p.print_proxy()
