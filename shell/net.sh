#!/bin/bash

in_old=$(awk -v i="$1" '$1~i{print $2}' /proc/net/dev)
out_old=$(awk -v i="$1" '$1~i{print $10}' /proc/net/dev)
sleep 1
in_now=$(awk -v i="$1" '$1~i{print $2}' /proc/net/dev)
out_now=$(awk -v i="$1" '$1~i{print $10}' /proc/net/dev)
printf "I: %d O: %d" $((($in_now-$in_old)/1024)) $((($out_now-$out_old)/1024))
