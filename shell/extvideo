#!/bin/bash
#######################################################################
# extract video clip as avi (Mpeg4) from video file
# 
# Kai Yuan
# kent.yuan at gmail dot com
#######################################################################
inputF=
if [ $# == 0 ]; then
echo -e "\

Extract video to avi (MPEG4) using mencoder

usage: ev.sh <input video file> <start timestamp> <offset>

example: ev.sh source.rmvb 01:20:33 00:50:00

above command will extract 50 minutes from 01:20:33 position from the source.rmvb file, convert to MPEG4 and save to source_new.avi.
"
exit 2

elif [ ! -f $1 ]; then
echo " ERROR: cannot find video file:$1"
    exit 1
elif [ ! -z $2 ]; then
test=$(echo $2 | grep "^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}$")
    if [ -z $test ]; then
echo "ERROR: start position timestamp format is not correct. e.g. 00:34:33"
        exit 1
    else
START=$test
        inputF=$1
    fi
fi


# extract video!!
mencoder $1 -ss $START -endpos $3 -ovc lavc -lavcopts vcodec=mpeg4:vhq:vbitrate=1600 -oac mp3lame -o  $(echo ${inputF%%.*})_NEW.avi 


