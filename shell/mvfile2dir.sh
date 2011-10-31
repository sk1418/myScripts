#!/bin/bash
##########################################################
# create dir with same name as file, and mv file in. e.g. /foo/a.txt a.jpg -> /foo/a/a.txt, a.jpg
#
# go through the BASEDIR, for each file, creating a directory
# with filename, and move the file into the directory.
# e.g. /test/a.txt -> /test/a/a.txt
#      /test/a.txt a.jpg b.jpg -> /test/a/a.txt a.jpg AND /test/b/b.jpg
#######################################################
BASEDIR="$1"/*

for MYFILE in $BASEDIR
do
    if [ -f $MYFILE ]
    then
       MYDIR=${MYFILE%.*}
       if [ ! -d $MYDIR ] #everything ok, mkdir, then move
       then
            `mkdir $MYDIR`
            `mv $MYFILE $MYDIR`
       else   # dir exists, only mv is needed.
            `mv $MYFILE $MYDIR`
       fi

    fi
done
