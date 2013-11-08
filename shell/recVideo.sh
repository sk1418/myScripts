#!/bin/bash
#==============================================
# capture video from webcam save as mp4 file
# 
# usage:
#	 recVideo [file]
#
# the video filename, if the argument was not given, 
# use default value /tmp/timestamp.mp4
# 
# Kent (kent.yuan at gmail.com)
# 2013-11-01
#==============================================

F=$1
#check argument, if not number or empty, set default duration
if [[ -z "$F" ]]; then 
	F="/tmp/$(date +%Y%m%d_%H%M%S).mp4"
fi
echo "==========================================="
echo "start recording..."
echo "==========================================="
ffmpeg -f video4linux2 -s 320x240 -i /dev/video0 -f alsa -ac 2 -i default -f mp4 -strict -2 $F
echo "==========================================="
echo "Captured video was saved as ${F}"
echo "==========================================="
