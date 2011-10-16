#!/bin/sh

title=$1
input=$2
prefix=$3

mencoder dvd://$title -dvd-device "$input" \
-oac mp3lame \
-lameopts mode=2:cbr:br=96:vol=0 \
-ovc lavc \
-lavcopts vcodec=mpeg4:vbitrate=2500:vhq:autoaspect \
-o "$prefix-$title.avi"
