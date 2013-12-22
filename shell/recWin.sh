#!/bin/bash
#==============================================
# A wrapper of byzanz-record, to ease x-window recording.
# 
# usage:
#	 recWin [duration]
#
# Duration in second, if it was omitted, use 
# default value
# 
# Kent (kent.yuan at gmail.com)
# 2013-01-11
#==============================================

D=$1
EXPORT_DIR="$HOME/Desktop/myTmp/GIF"
#check argument, if not number or empty, set default duration
if [[ -z "$D" || -n ${D//[0-9]/} ]]; then 
	D=10 #default 10s
fi
echo "Durtion of animation: ${D}"

#the tmp file to store xwindow info
TMP=/tmp/wsize.tmp 

#the recorded file path
GIF=$EXPORT_DIR/$(date +%Y%m%d_%H%M%S).gif

echo "please click the window you want to record.."
xwininfo -frame > $TMP

X=$(awk -F: '/Absolute upper-left X:/{print $2}' $TMP)
Y=$(awk -F: '/Absolute upper-left Y:/{print $2}' $TMP)
WIDTH=$(grep -Po "(?<=Width: )\d+" $TMP)
HEIGHT=$(grep -Po "(?<=Height: )\d+" $TMP)

byzanz-record -d $D -x $X -y $Y -w $WIDTH -h $HEIGHT $GIF
echo "GIF animation was saved as ${GIF}"
