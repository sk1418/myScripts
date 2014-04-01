#!/usr/bin/python2
###################################################
# unzip zip file, convert GBK encoded filename into UTF8
#
# Author : Kent 2014.02.01
# Email  : kent dot yuan at gmail dot com.
#
###################################################
# -*- coding: utf-8 -*-

import os
import sys
import zipfile

style={
        'error':u'\x1b[31;1m',
        'info':u'\x1b[34m'
        }

def msg(style_key,text):
    clear = u'\x1b[0m'
    print '%s[%s] %s %s' % (style[style_key],style_key,text,clear)

    
def main(the_zip):
    fn = the_zip.decode('utf-8')
    msg( 'info', u'unzip file: %s' % fn)
    zf=zipfile.ZipFile(the_zip,'r');

    for name in zf.namelist():
        utf8name=name.decode('gbk')
        msg('info', u'Extracting %s' % utf8name)
        pathname = os.path.dirname(utf8name)
        if not os.path.exists(pathname) and pathname!= '':
            os.makedirs(pathname)
        data = zf.read(name)
        if not os.path.exists(utf8name):
            with open(utf8name, 'w') as fo:
                fo.write(data)
    zf.close()

if __name__ == '__main__':
    if len(sys.argv)<2 or not sys.argv[1] or not sys.argv[1].endswith('.zip'):
        msg('error','need a zip file as parameter')
        sys.exit(1)

    if not os.path.isfile(sys.argv[1]):
        msg('error','the zip file does not exist, double check the path')
        sys.exit(1)

    main(sys.argv[1])

# vim: ft=python
