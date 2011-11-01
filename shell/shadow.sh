#!/bin/bash
#######################################################################
# add shadow to a png image
#
# Kai Yuan
# kent.yuan at gmail dot com
#######################################################################


if [ $# == 0 ]; then 
	cat <<EOF
	$0 adds shadow to given png image. 
	Usage: $0 <input png image>
	output filename is original filename with "_new" suffix
EOF
    exit 2
fi

convert $1 \( +clone -background black -shadow 55x15+0+5 \) +swap -background none -layers merge  +repage $1_new.png
