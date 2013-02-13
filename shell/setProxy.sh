#!/bin/bash 
#
#[STOP_USED]switch proxy settings, since python application "tinySwitch" was build, this script is NOT used any longer.
#
# Proxy-Authorization should already been added in tinyproxy.conf
#AddHeader "Proxy-Authorization" "Basic VThDSVVDSEk6aDh4OGh5bXE="
# 
#
# Kai Yuan
lht6=57.20.4.6:8080
lht7=57.20.4.7:8080

#Default lht proxy
lht=$lht6

CONFIG=/etc/tinyproxy.conf




#set lht proxies
setLhtProxy(){
    
    sed -ri "s/^[#]?upstream .*$/upstream $1/" $CONFIG
    sed -ri "s/^[#]?AddHeader (\"Proxy-Authorization.*$)/AddHeader \1/" $CONFIG
} 

#set no proxy
setNoProxy(){
    sed -ri "s/^(upstream .*$)/#\1/" $CONFIG
    sed -ri "s/^(AddHeader \"Proxy-Authorization.*$)/#\1/" $CONFIG
}

#need root(sudo) permission to run the script
if [ $(id -u) -ne 0 ];then
    echo "[Error] You need to be root to change proxy settings!"
    exit 1
fi

case $1 in
    lht)
        setLhtProxy $lht
        ;;
    lht6)
        setLhtProxy $lht6
        ;;
    lht7)
        setLhtProxy $lht7
        ;;
    no)
        setNoProxy 
        ;;
    *)
        echo "Usage: setProxy (no|lht|lht6|lht7)"
        exit 0
        ;;
esac

etc/init.d/tinyproxy reload
if [ $? -eq 0 ];then
    echo "==-------------------------------------=="
    echo "  Proxy was successfully set to "$1".   "
    echo "  upstream and HEADER info of tinyproxy "
    echo "==-------------------------------------=="
    sed -nr '/[#]?AddHeader "Proxy.*/p; /^[#]?upstream /p;' $CONFIG
fi
