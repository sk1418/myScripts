#!/usr/bin/python
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
# update 2016-01-01  add peuland.com proxies
###################################################
# -*- coding: utf-8 -*-

import sys, re, requests,json
from bs4 import BeautifulSoup
import base64

BORDER='>>>>>>>>>>>>>>>>>>>>>>>>>>>'
PROXY_POOL_1 = 'proxy-list.org proxies:'
PROXY_POOL_URL_1 = 'http://proxy-list.org/english/search.php?search=CN&country=CN&type=any&port=any&ssl=any&p=%d'
PROXY_POOL_2 = 'peuland.com proxies:'
PROXY_POOL_URL_2 = 'https://proxy.peuland.com/proxy/search_proxy.php'

class Proxy(object):
    def __init__(self, value, speed):
        self.value = value
        self.speed = int(speed)

    def print_proxy(self):
        clear = u'\x1b[0m'
        style={
            'red':u'\x1b[31;1m',
            'green':u'\x1b[34m'
            }
        print('%s%s\t%s%s(kib or ranking)%s' % (style["green"],self.value, style["red"], self.speed, clear))


def parse_proxies_1():
    page = 1
    #empty list
    proxies = []
    while True:
        html = requests.get(PROXY_POOL_URL_1%page).text
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

def parse_proxies_2():
    AGENT= 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36'
    #headers
    HEADERS = {'User-Agent':AGENT}
    HEADERS['Referer'] = 'https://proxy.peuland.com/proxy_list_by_category.htm'
    HEADERS['Cookie'] = 'rand_id=jhk8uidlhofo55ulsfu0vrnli3;php_id=628472250;peuland_id=35fefe23fedc52da9283ac5ed131cbab;peuland_md5=ca1f57155f5638ade3c28a900fbdbd55; w_h=1024; w_w=1280; w_cd=24; w_a_h=1024; w_a_w=1280'
    proxies = []
    s = requests.Session()
    i=max_page = 1
    while (i<=max_page):
        r = s.post(PROXY_POOL_URL_2, headers=HEADERS, data = {"country_code":"cn", "search_type":"all","page":str(i)})
        txt = re.sub(r'^[^{]*', '', r.text)
        # servers_json = r.json()['data']
        json_obj = json.loads(txt)
        servers_json = json_obj['data']
        for server in servers_json:
            rate = int(base64.b64decode(server['time_downloadspeed']))
            if rate <=7 :
                continue
            proxy = Proxy(\
                        "%s:%s"%(base64.b64decode(server['ip']).decode(), \
                                base64.b64decode(server['port']).decode()),\
                                rate)
            proxies.append(proxy) 
        # max_page = int(r.json()['pagination']['maxpage'])
        max_page = int(json_obj['pagination']['maxpage'])
        i+=1
    if proxies:
        return sorted(proxies,key=lambda x : x.speed, reverse=True)

if __name__ == '__main__':
    n = 5 if len(sys.argv)<2 or int(sys.argv[1])<=0 else int(sys.argv[1])
    #test peuland proxies only
    proxies = parse_proxies_2()
    n = len(proxies) if len(proxies) < n else n
    for p in proxies[:n]:
        p.print_proxy()
