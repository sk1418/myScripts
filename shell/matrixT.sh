#!/bin/bash
#########################################
# Matrix transpose with Awk
#
# Kai Yuan
# kent.yuan at gmail dot com
#
# 2011-07-07
#
#########################################
fs=
file=$1

if [ $# == 2 ]; then
	fs=$2
fi

awk  "BEGIN{FS='$fs'}{for (i=1;i<=NF;i++) a[i,NR]=$i; }END{
    for(i=1;i<=NF;i++) {
        for(j=1;j<=NR;j++)
            printf a[i,j]' ';
        print ''
    } 
}" $file
