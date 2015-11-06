#!/bin/bash
#######################################################################
# read proxy from proxy-list.org and update a proxy.pac file. 
# The setting must be reloaded in FF setting->advanced->Network
# 
# Kai Yuan
# kent.yuan at gmail dot com
#######################################################################

#firefox dir
PAC_FILE="$HOME/firefoxProxy.pac"

echo "Loading the fastest cn proxy..."
PROXY_RAW=$(python2 ../python/cnProxy.py|head -1)
echo "$PROXY_RAW"
PROXY=$(grep -oP '[0-9.]+:\d+' <<< "$PROXY_RAW")
echo "==============================="
echo "Appling the proxy on pac file: $PAC_FILE"
sed -i -r  "/var\s+china_proxy=/s/[0-9.]+:[0-9]+/$PROXY/" $PAC_FILE
echo "Done"
echo "==============================="
echo "In firefox network settings tab reload the pac file."

