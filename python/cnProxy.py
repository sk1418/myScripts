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
# update 2016-11-22  peuland.com has changed some cookies' names
###################################################
# -*- coding: utf-8 -*-

import time, sys, re, requests,json
from bs4 import BeautifulSoup
import base64

BORDER='>>>>>>>>>>>>>>>>>>>>>>>>>>>'
PROXY_POOL_1 = 'proxy-list.org proxies:'
PROXY_POOL_URL_1 = 'http://proxy-list.org/english/search.php?search=CN&country=CN&type=any&port=any&ssl=any&p=%d'
PROXY_POOL_2 = 'peuland.com proxies:'
PROXY_POOL_URL_2 = 'https://proxy.peuland.com/proxy/search_proxy.php'

PROXY_POOL_3 = 'free-proxy.cz proxies:'
PROXY_POOL_URL_3 = 'http://free-proxy.cz/en/proxylist/country/CN/http/ping/all/%d'
class Proxy(object):
    def __init__(self, value, response=-1, speed=-1):
        self.value = value
        self.response = response
        self.speed = speed

    def print_proxy(self):
        clear = u'\x1b[0m'
        style={
            'red':u'\x1b[31;1m',
            'green':u'\x1b[34m'
            }
        print('%s%-25s\t%sspeed: %d\tresponse: %d ms%s' % (style["green"],self.value,style["red"],self.speed, self.response, clear))


def parse_proxies_3():
    page = 1
    #empty list
    proxies = []
    # raw=open('/tmp/foo.html','r')
    # while True:
    html = requests.get(PROXY_POOL_URL_3 % page).text
    # html = raw
    # if not html or page >3:
        # break;
    table = BeautifulSoup(html, 'html.parser').find(id="proxy_list").find('tbody')
    rows = table.find_all('tr')
    #only take http/s
    rows = list(filter(lambda tr: len(tr.contents)>5 and re.match(r'^http', tr.contents[2].text, re.I), rows))
    for row in rows:
        ip = base64.b64decode(re.split(r"[\"\']",row.contents[0].text)[1])
        port = row.contents[1].text
        response = re.split(r'\s*ms',row.contents[-2].text)[0] # "1234 ms"
        proxies.append(Proxy("%s:%s"%(ip.decode('UTF-8'),port), response = int(response)))
    # page += 1
    # time.sleep(1)
    if proxies:
        return sorted(proxies,key=lambda x : x.response)

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
        for proxy_tag in proxy_tags:
            proxy_server = base64.b64decode(re.split(r"[\"\']",proxy_tag.string)[1])
            proxy_server =proxy_server.decode('utf-8') if proxy_server else '---'
            proxies.append(Proxy(proxy_server))
        page += 1
    if proxies:
        return sorted(proxies,key=lambda x : x.speed, reverse=True)

def parse_proxies_2():
    AGENT= 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36'
    #headers
    HEADERS = {'User-Agent':AGENT}
    HEADERS['Referer'] = 'https://proxy.peuland.com/proxy_list_by_category.htm'
    HEADERS['Cookie'] = 'php_id=493316247; CNZZDATA1253154494=1665531259-1479808141-%7C1479808141;peuland_md5=9b941affd9b676f62ab93081f6cc9a1b; w_h=1200; w_w=1920; w_cd=24; w_a_h=1147; w_a_w=1920;peuland_id=649e2152bad01e29298950671635e44a;'
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
    proxies = parse_proxies_3()
    n = len(proxies) if len(proxies) < n else n
    for p in proxies[:n]:
        p.print_proxy()
